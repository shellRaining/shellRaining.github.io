---
title: element plus 使用自动导入插件后，样式未生效
tag:
  - QA
---

# {{ $frontmatter.title }}

## 问题描述

在使用 element plus 的时候，按照官方文档，使用了自动导入插件 `unplugin-vue-components` 和
`unplugin-auto-import`，自动导入在使用组件 (比如 `el-button`) 的时候没有问题，但是在使用样式的时候 (比如
`var(--el-border-color)`) 未生效，相关配置均和官方相同

```ts
// vite.config.ts

// ...
import AutoImport from "unplugin-auto-import/vite";
import Components from "unplugin-vue-components/vite";
import { ElementPlusResolver } from "unplugin-vue-components/resolvers";

export default defineConfig({
  plugins: [
    AutoImport({
      resolvers: [ElementPlusResolver()],
      dts: true,
    }),
    Components({
      resolvers: [ElementPlusResolver()],
      dts: true,
    }),
  ],
  // ...
});
```

最小复现代码如下

```vue
<!-- App.vue -->
<template>
  <div class="radius" :style="{ borderRadius: `var(--el-border-radius-round)` }"></div>
</template>

<script lang="ts" setup>
// import 'element-plus/es/components/message/style/css'
</script>

<style scoped>
.radius {
  height: 40px;
  width: 70%;
  border: 1px solid red;
  margin-top: 20px;
}
</style>
```

其中上面的 Vue 代码在 [https://element-plus.run](https://element-plus.run)
中可以正常显示，正常显示应该是胶囊状的边框，但是在本地运行后，样式未生效，如果取消 script 中的注释，样式可以正常显示

这个问题在官方文档 `按需引入` 中没有给出解决方案，只是在后面 `手动导入` 章节有提到

我想问的问题如下

1. 这个问题是 `unplugin-vue-components` 或者 `unplugin-auto-import` 造成的吗
1. 我这样导入 `import 'element-plus/es/components/message/style/css'` 有什么问题吗
   (比如造成打包体积过大)

## 解决方案

这个问题没有得到回答，但是我问了 GPT，相关内容如下

首先第一个问题

> 这个问题是 `unplugin-vue-components` 或者 `unplugin-auto-import` 造成的吗

极有可能，因为这些插件是用来导入组件的，而不是导入样式的，可以通过手动导入样式来解决。

第二个问题

> 我这样导入 `import 'element-plus/es/components/message/style/css'` 有什么问题吗

没有问题，而且 GPT 中也推荐这个方法(即组件自动导入，样式手动导入)

<!-- AIGC，需要校验 -->
