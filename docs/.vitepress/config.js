export default {
  title: 'ShellRaining Blog',
  description: 'Just playing around.',
  cleanUrls: true,
  themeConfig: {
    siteTitle: 'shellRaining Blog',
    nav: [
      { text: 'Github', link: 'https://github.com/shellRaining' },
    ],
    sidebar: [
      {
        text: 'vitepress',
        collapsed: true,
        items: [
          { text: 'Introduction', link: '/index' },
        ],
      },
      {
        text: 'javascript',
        collapsed: true,
        items: [
          { text: 'oop', link: '/javascript/oop' },
          { text: 'reflect', link: '/javascript/reflect' },
        ],
      },
      {
        text: 'npm',
        collapsed: true,
        items: [
          { text: 'index', link: '/npm/index' },
          { text: 'package.json', link: '/npm/package_json_usage' },
        ],
      },
    ],
    editLink: {
      pattern: 'https://github.com/shellRaining/shellRaining.github.io',
    },
  },
}
