import { getThemeConfig, defineConfig } from '@sugarat/theme/node'

const blogTheme = getThemeConfig({
  author: 'shellRaining',
})

export default defineConfig({
  lang: 'zh-cmn-Hans',
  title: 'shellRaining blog',
  description: 'this is fork from sugar blog',
  vite: {
    optimizeDeps: {
      include: ['element-plus'],
      exclude: ['@sugarat/theme']
    }
  },
  themeConfig: {
    ...blogTheme,
    lastUpdatedText: '上次更新于',
  }
})

