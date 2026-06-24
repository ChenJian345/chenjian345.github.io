import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://chenjian345.github.io',
  image: {
    service: {
      entrypoint: 'astro/assets/services/noop',
    },
  },
  markdown: {
    shikiConfig: {
      theme: 'github-dark',
      wrap: true,
    },
  },
});
