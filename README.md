# Crazy Mark Blog

Personal technical blog powered by [Astro](https://astro.build/), deployed with GitHub Pages.

## Development

```sh
npm install
npm run dev
```

## Build

```sh
npm run build
```

## Deploy

Deploy an already committed, clean branch to GitHub Pages:

```sh
npm run deploy
```

Commit only explicit files and deploy them in one command:

```sh
npm run deploy -- --commit "Describe the change" -- path/to/file another/file
```

The script validates that the branch can fast-forward `master`, runs the production build, waits for GitHub Pages, and verifies affected URLs. See `AGENTS.md` for the concise AI-tool workflow.

## Content

Blog posts live in `src/content/blog`. Each post should include frontmatter with `title`, `pubDate`, `slug`, `category`, `tags`, and `excerpt`.
