import type { APIRoute } from 'astro';
import { getCollection } from 'astro:content';

export const GET: APIRoute = async () => {
  const posts = await getCollection('blog');
  const site = 'https://chenjian345.github.io';

  const pages = [
    { url: '/', lastmod: new Date().toISOString(), priority: '1.0' },
    { url: '/about', lastmod: '2024-01-01', priority: '0.5' },
    { url: '/category/iOS', lastmod: new Date().toISOString(), priority: '0.6' },
    { url: '/category/技术', lastmod: new Date().toISOString(), priority: '0.6' },
    { url: '/category/设计', lastmod: new Date().toISOString(), priority: '0.6' },
    { url: '/category/工具', lastmod: new Date().toISOString(), priority: '0.6' },
    { url: '/category/技术调研', lastmod: new Date().toISOString(), priority: '0.6' },
  ];

  const postEntries = posts.map(post => ({
    url: `/blog/${post.data.slug}/`,
    lastmod: new Date(post.data.pubDate).toISOString(),
    priority: '0.8',
  }));

  const allUrls = [...pages, ...postEntries];

  const sitemap = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${allUrls.map(entry => `  <url>
    <loc>${site}${entry.url}</loc>
    <lastmod>${entry.lastmod.split('T')[0]}</lastmod>
    <priority>${entry.priority}</priority>
  </url>`).join('\n')}
</urlset>`;

  return new Response(sitemap, {
    headers: {
      'Content-Type': 'application/xml',
    },
  });
};
