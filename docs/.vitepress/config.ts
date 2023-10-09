import { getThemeConfig, defineConfig } from "@sugarat/theme/node";
import {
  chineseSearchOptimize,
  pagefindPlugin,
} from "vitepress-plugin-pagefind";

const blogTheme = getThemeConfig({
  author: "shellRaining",
  home: {
    motto: "始不垂翅，终能奋翼",
    pageSize: 10,
  },
  search: "pagefind",
  article: {
    readingTime: true,
  },
});

export default defineConfig({
  extends: blogTheme,
  lang: "zh-cn",
  vite: {
    plugins: [
      pagefindPlugin({
        customSearchQuery: chineseSearchOptimize,
        btnPlaceholder: "搜索",
        placeholder: "搜索文档",
        emptyText: "空空如也",
        heading: "共: {{searchResult}} 条结果",
      }),
    ],
  },
  themeConfig: {
    lastUpdatedText: "上次更新于",
    logo: "https://raw.githubusercontent.com/shellRaining/img/main/head/keqing.jpeg",
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
