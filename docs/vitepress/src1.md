---
title: 阅读 sugar theme 的源代码（源代码1）
tag:
  - vitepress
description: 本站使用的主题就是 sugar，但是和我的目标不符合，所以希望阅读源码并修改，此处为第一步：阅读源码
---

# 阅读 sugar 源代码（源代码 index.ts）

## 模块引入

```typescript
// override style
import "./styles/index.scss";

// element-ui
import "element-plus/dist/index.css";
import "element-plus/theme-chalk/dark/css-vars.css";

import { Theme } from "vitepress"; // [!code focus]
import DefaultTheme from "vitepress/theme"; // [!code focus]
import BlogApp from "./components/BlogApp.vue"; // [!code focus]
import { withConfigProvider } from "./composables/config/blog"; // [!code focus]

// page
import TimelinePage from "./components/TimelinePage.vue"; // [!code focus]
```

首先排除样式和第三方模块，首先从 `vitepress` 引入了默认主题，然后从组件目录下引入了 `BlogApp` 和 `TimelinePage`，最后引入了组装件里面的一个配置提供函数 `withConfigProvider`

## 模块导出

```typescript
export const BlogTheme: Theme = {
  ...DefaultTheme,
  Layout: withConfigProvider(BlogApp),
  enhanceApp(ctx) {
    ctx.app.component("TimelinePage", TimelinePage);
  },
};

export * from "./composables/config/index";

export default BlogTheme;
```

首先我们导出了 `BlogTheme` 主题，他是一个实现了 `THEME` 接口的对象，然后我们将组合件目录下的所有导出对象从此导出，并设置默认导出为 `BlogTheme`
