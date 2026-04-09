import rss from '@astrojs/rss';
import { getCollection } from 'astro:content';

export async function GET(context) {
  const posts = await getCollection('blog');
  const sortedPosts = posts.sort(
    (a, b) => new Date(b.data.pubDate).getTime() - new Date(a.data.pubDate).getTime()
  );

  return rss({
    title: 'Crazy Mark',
    description: 'Software Developer Blog',
    site: context.site,
    items: sortedPosts.map(post => ({
      title: post.data.title,
      pubDate: new Date(post.data.pubDate),
      link: `/blog/${post.slug}/`,
    })),
    customData: `<language>zh-CN</language>`,
  });
}
