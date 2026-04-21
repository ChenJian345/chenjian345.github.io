import { defineCollection, z } from 'astro:content';

const blog = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    pubDate: z.string(),
    tags: z.array(z.string()).default([]),
    category: z.string().default('技术'),
    excerpt: z.string().optional(),
    description: z.string().optional(),
  }),
});

export const collections = { blog };
