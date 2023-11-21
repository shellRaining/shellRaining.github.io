---
title: vitepress blog 创建记录 (一)
tag:
  - diary
  - vitepress
---

# {{ $frontmatter.title }}

## 自定义主题

`vitepress` 可以通过添加一个入口文件来进行自定义,该入口文件始终是 `.vitepress/theme/index.ts` 或者
`.vitepress/theme/index.js`

在该文件中,我们需要默认导出自定义的主题 (主题是一个具有特定结构的对象,在 TypeScript 中为 `Theme` 类型)

在主题对象中,我们必须实现的字段是 `Layout`,可以通过
[useData()](https://vitepress.dev/reference/runtime-api#usedata) (在 `vitepress`
中具名导出)

通过使用 `useData` 中的信息可以根据 `frontmatter` 不同来设置不同的页面,

## 拓展默认主题

可以通过 `vitepress/theme` 中的 `DefaultTheme` 默认导出
