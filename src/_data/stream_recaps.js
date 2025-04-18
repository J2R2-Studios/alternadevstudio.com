/**
 * Data file for stream recaps
 */

export default function() {
  console.log('Stream recaps data file loaded');
  
  return [
    {
      id: 1,
      title: 'Building a Headless CMS with Directus',
      slug: 'building-headless-cms-directus',
      stream_date: new Date('2025-04-12T19:00:00Z'),
      topics_covered: ['Directus', 'Headless CMS', 'Docker', 'API', 'Eleventy'],
      code_repository: 'https://github.com/alternadev/directus-demo',
      duration_minutes: 120,
      featured: true
    },
    {
      id: 2,
      title: 'Advanced Eleventy Techniques',
      slug: 'advanced-eleventy-techniques',
      stream_date: new Date('2025-04-05T19:00:00Z'),
      topics_covered: ['Eleventy', 'Nunjucks', 'JavaScript', 'Static Site Generation', 'Performance'],
      code_repository: 'https://github.com/alternadev/eleventy-advanced',
      duration_minutes: 90,
      featured: true
    }
  ];
}
