# Repository Guide for AI Tools

## Project

- Astro static blog deployed to GitHub Pages.
- Production URL: `https://chenjian345.github.io`.
- Pushes to `master` trigger `.github/workflows/deploy.yml`.
- Blog posts: `src/content/blog/*.md`; static assets: `public/`.

## Required Checks

- Install from the lockfile when dependencies are missing: `npm ci`.
- Production validation: `npm run build`.
- Do not upload `dist/` manually; GitHub Actions builds and publishes it.
- Never force-push for deployment.

## One-Command Deployment

For an already committed, clean, fast-forward branch:

```sh
npm run deploy
```

To commit only explicit files and deploy in one command:

```sh
npm run deploy -- --commit "Describe the change" -- path/to/file another/file
```

Preflight without committing or pushing:

```sh
npm run deploy -- --dry-run
```

The script fetches `origin/master`, rejects divergent history or hidden extra changes, builds locally, pushes `HEAD:master`, waits until `/deploy.txt` reports the pushed commit, and verifies affected article and asset URLs. Use it instead of rediscovering the deployment workflow.

## Content Conventions

- Frontmatter must include `title`, `pubDate`, `slug`, `category`, `tags`, and `excerpt`.
- Internal article links use `/blog/<slug>`.
- Assets under `public/` are referenced from the site root, for example `/images/example.svg`.
- Keep factual AI claims qualified when architectures, model sizes, defaults, or hardware requirements are not officially confirmed.
