import rss from '@astrojs/rss';
import { getCollection } from 'astro:content';
import type { APIRoute } from 'astro';

export const GET: APIRoute = async (context) => {
  const posts = (await getCollection('blog')).sort(
    (a, b) => new Date(b.data.pubDate).getTime() - new Date(a.data.pubDate).getTime()
  );

  return rss({
    title: 'Crazy Mark',
    description: 'Mark Chen 的技术实践、AI 学习与长期积累。',
    site: context.site ?? 'https://chenjian345.github.io',
    items: posts.map((post) => ({
      title: post.data.title,
      description: post.data.description ?? post.data.excerpt ?? post.data.title,
      link: `/blog/${post.data.slug}/`,
      pubDate: new Date(post.data.pubDate),
      categories: [...new Set([post.data.category, ...post.data.tags])],
    })),
  });
};
