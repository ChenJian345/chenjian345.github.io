import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const blog = defineCollection({
  loader: glob({
    pattern: '**/*.md',
    base: './src/content/blog',
    generateId: ({ entry }) => entry.replace(/\.md$/, ''),
  }),
  schema: z.object({
    title: z.string(),
    pubDate: z.string(),
    slug: z.string(),
    tags: z.array(z.string()).default([]),
    category: z.string().default('技术'),
    excerpt: z.string().optional(),
    description: z.string().optional(),
  }),
});

export const collections = { blog };
