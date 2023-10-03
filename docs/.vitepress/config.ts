import { getThemeConfig, defineConfig } from "@sugarat/theme/node";

const blogTheme = getThemeConfig({
  author: "shellRaining",
});

export default defineConfig({
  lang: "zh-cmn-Hans",
  title: "shellRaining blog",
  description: "this is fork from sugar blog",
  vite: {
    optimizeDeps: {
      include: ["element-plus"],
      exclude: ["@sugarat/theme"],
    },
  },
  extends: blogTheme,
  themeConfig: {
    lastUpdatedText: "上次更新于",
    search: {
      provider: "local",
    },
    logo: "https://raw.githubusercontent.com/shell-Raining/img/main/head/keqing.jpeg",
    nav: [
      {
        text: "hlchunk.nvim",
        link: "https://github.com/shellRaining/hlchunk.nvim",
      },
      { text: "roadmap", link: "/roadmap" },
      { text: "about me", link: "/about" },
    ],
  },
});
