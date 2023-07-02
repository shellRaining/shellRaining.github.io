import { getThemeConfig, defineConfig } from "@sugarat/theme/node";
import { withMermaid } from "vitepress-plugin-mermaid";

const blogTheme = getThemeConfig({
  author: "shellRaining",
});

// export default defineConfig({
//   lang: "zh-cmn-Hans",
//   title: "shellRaining blog",
//   description: "this is fork from sugar blog",
//   vite: {
//     optimizeDeps: {
//       include: ["element-plus"],
//       exclude: ["@sugarat/theme"],
//     },
//   },
//   extends: blogTheme,
//   themeConfig: {
//     lastUpdatedText: "上次更新于",
//     nav: [
//       {
//         text: "hlchunk.nvim",
//         link: "https://github.com/shellRaining/hlchunk.nvim",
//       },
//       { text: "about me", link: "/about" },
//     ],
//   },
// });

export default withMermaid(
  defineConfig({
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
      nav: [
        {
          text: "hlchunk.nvim",
          link: "https://github.com/shellRaining/hlchunk.nvim",
        },
        { text: "about me", link: "/about" },
      ],
    },
  })
);
