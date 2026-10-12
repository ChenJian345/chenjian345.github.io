#!/usr/bin/env bash

set -euo pipefail

readonly DEFAULT_SITE_URL="https://chenjian345.github.io"
readonly DEFAULT_WORKFLOW="deploy.yml"
readonly DEFAULT_TIMEOUT_SECONDS=600

commit_message=""
install_dependencies=0
dry_run=0
declare -a deploy_paths=()
deploy_path_count=0
staged_by_script=0

usage() {
  cat <<'EOF'
Usage:
  npm run deploy
  npm run deploy -- --commit "Commit message" -- path/to/file [more/files...]
  npm run deploy -- --ci
  npm run deploy -- --dry-run

Options:
  --commit MESSAGE  Stage only the explicit paths after --, commit, and deploy.
  --ci              Run npm ci even when dependencies are already installed.
  --dry-run         Fetch, validate, and build without committing or pushing.
  -h, --help        Show this help.

Environment:
  SITE_URL                 Site URL to verify after deployment.
  DEPLOY_WORKFLOW          GitHub Actions workflow file name.
  DEPLOY_TIMEOUT_SECONDS   Maximum wait for GitHub Pages (default: 600).
EOF
}

fail() {
  printf 'deploy: %s\n' "$*" >&2
  exit 1
}

cleanup_staging() {
  if [[ "$staged_by_script" -eq 1 && "$deploy_path_count" -gt 0 ]]; then
    git restore --staged -- "${deploy_paths[@]}" >/dev/null 2>&1 || true
  fi
}

on_exit() {
  local status=$?
  trap - EXIT
  cleanup_staging
  exit "$status"
}

trap on_exit EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

while [[ $# -gt 0 ]]; do
  case "$1" in
    --commit)
      [[ $# -ge 2 ]] || fail "--commit requires a message"
      commit_message="$2"
      shift 2
      ;;
    --ci)
      install_dependencies=1
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      while [[ $# -gt 0 ]]; do
        deploy_paths+=("$1")
        deploy_path_count=$((deploy_path_count + 1))
        shift
      done
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

[[ -z "$commit_message" || "$deploy_path_count" -gt 0 ]] || \
  fail "--commit requires explicit repository-relative paths after --"
[[ "$dry_run" -eq 0 || -z "$commit_message" ]] || \
  fail "--dry-run cannot be combined with --commit"

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || fail "not inside a Git repository"
cd "$repo_root"

if [[ "$deploy_path_count" -gt 0 ]]; then
  for path in "${deploy_paths[@]}"; do
    case "$path" in
      /*|..|../*|*/../*|*/..)
        fail "path must stay inside the repository: $path"
        ;;
    esac
    [[ -e "$path" ]] || git ls-files --error-unmatch -- "$path" >/dev/null 2>&1 || \
      fail "path does not exist and is not a tracked deletion: $path"
  done
fi

printf '==> Fetching origin/master\n'
git fetch origin master
git merge-base --is-ancestor origin/master HEAD || \
  fail "HEAD is not based on the latest origin/master; rebase or merge before deploying"

if [[ -n "$commit_message" ]]; then
  git diff --cached --quiet || fail "pre-existing staged changes found; commit or unstage them first"

  git add -- "${deploy_paths[@]}"
  staged_by_script=1

  if ! git diff --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    fail "working tree contains changes outside the explicit deploy paths"
  fi
  git diff --cached --quiet && fail "the explicit deploy paths contain no changes"
elif [[ "$dry_run" -eq 0 && -n "$(git status --porcelain)" ]]; then
  fail "working tree is not clean; commit first or use --commit with explicit paths"
fi

if [[ "$install_dependencies" -eq 1 || ! -x node_modules/.bin/astro ]]; then
  printf '==> Installing locked dependencies\n'
  npm ci
fi

printf '==> Building production site\n'
CI=true ASTRO_TELEMETRY_DISABLED=1 npm run build

if [[ "$dry_run" -eq 1 ]]; then
  printf '==> Dry run passed; nothing was committed or pushed\n'
  exit 0
fi

if [[ -n "$commit_message" ]]; then
  printf '==> Committing explicit deploy paths\n'
  git commit -m "$commit_message"
  staged_by_script=0
fi

git merge-base --is-ancestor origin/master HEAD || \
  fail "HEAD diverged from origin/master during deployment"
[[ "$(git rev-parse HEAD)" != "$(git rev-parse origin/master)" ]] || \
  fail "HEAD is already deployed; there is no new commit to push"

head_sha="$(git rev-parse HEAD)"
changed_files="$(git diff --name-only origin/master..HEAD)"

printf '==> Pushing %s to master\n' "${head_sha:0:8}"
git push origin HEAD:master

remote_url="$(git remote get-url origin)"
repo_slug="$(printf '%s' "$remote_url" | sed -E 's#^git@github\.com:##; s#^ssh://git@github\.com/##; s#^https://github\.com/##; s#\.git$##')"
[[ "$repo_slug" == */* ]] || fail "cannot derive GitHub repository from origin: $remote_url"

workflow="${DEPLOY_WORKFLOW:-$DEFAULT_WORKFLOW}"
timeout_seconds="${DEPLOY_TIMEOUT_SECONDS:-$DEFAULT_TIMEOUT_SECONDS}"
site_url="${SITE_URL:-$DEFAULT_SITE_URL}"
site_url="${site_url%/}"
action_url="https://github.com/$repo_slug/actions/workflows/$workflow"
marker_url="$site_url/deploy.txt"

printf '==> Waiting for GitHub Pages deployment marker\n'
started_at="$(date +%s)"
attempt=0
while true; do
  attempt=$((attempt + 1))
  deployed_sha="$(curl --fail --silent --location \
    --header 'Cache-Control: no-cache' \
    "$marker_url?deploy=$head_sha&attempt=$attempt" 2>/dev/null || true)"

  if [[ "$deployed_sha" == "$head_sha" ]]; then
    printf '    deployed: %s\n' "${head_sha:0:8}"
    break
  fi

  now="$(date +%s)"
  (( now - started_at < timeout_seconds )) || \
    fail "deployment marker timed out; check $action_url"
  printf '    waiting: %s\n' "${deployed_sha:-marker unavailable}"
  sleep 15
done

declare -a verify_urls=("$site_url/")
while IFS= read -r file; do
  case "$file" in
    src/content/blog/*.md)
      [[ -e "$file" ]] || continue
      slug="$(sed -nE 's/^slug:[[:space:]]*"?([^"]+)"?[[:space:]]*$/\1/p' "$file" | head -1)"
      [[ -z "$slug" ]] || verify_urls+=("$site_url/blog/$slug/")
      ;;
    public/*)
      [[ -e "$file" ]] && verify_urls+=("$site_url/${file#public/}")
      ;;
  esac
done <<< "$changed_files"

printf '==> Verifying deployed URLs\n'
for url in "${verify_urls[@]}"; do
  curl --fail --silent --show-error --location --retry 6 --retry-delay 5 \
    --retry-all-errors --output /dev/null "$url?deploy=$head_sha"
  printf '    ok: %s\n' "$url"
done

printf '==> Deployment complete\n'
printf '    commit: %s\n' "$head_sha"
printf '    action: %s\n' "$action_url"
printf '    site:   %s\n' "$site_url"
