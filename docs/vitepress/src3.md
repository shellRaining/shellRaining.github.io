---
title: 阅读 sugar theme 的源代码（源代码3）
tag:
  - vitepress
description: 本站使用的主题就是 sugar，但是和我的目标不符合，所以希望阅读源码并修改，此处为第一步：阅读源码
---

# 阅读 sugar 源代码（源代码 BlogApp.vue）

## script 部分

```vue
<script setup lang="ts" name="BlogApp">
import Theme from "vitepress/theme";

import BlogHomeInfo from "./BlogHomeInfo.vue";
import BlogHomeBanner from "./BlogHomeBanner.vue";
import BlogList from "./BlogList.vue";
import BlogComment from "./BlogComment.vue";
import BlogSearch from "./BlogSearch.vue";
import BlogSidebar from "./BlogSidebar.vue";
import BlogImagePreview from "./BlogImagePreview.vue";
import BlogArticleAnalyze from "./BlogArticleAnalyze.vue";
import BlogAlert from "./BlogAlert.vue";
import BlogPopover from "./BlogPopover.vue";

import { useBlogThemeMode } from "../composables/config/blog";

const isBlogTheme = useBlogThemeMode();
const { Layout } = Theme;
</script>
```

这部分先是引入默认的主题，然后导入了很多自己写的组件，暂且按下不表

这之后是从组合件处引入了一个函数，并用其确定了一个 `isBlogTheme` 变量，最终解构赋值了 Layout 变量

## template 部分

```vue
<template>
  <Layout>
    <template #layout-top>
      <BlogAlert />
      <BlogPopover />
    </template>

    <template #doc-before>
      <!-- 阅读时间分析 -->
      <ClientOnly>
        <BlogArticleAnalyze />
      </ClientOnly>
      <!-- 图片预览 -->
      <BlogImagePreview />
    </template>

    <!-- 自定义搜索，临时替代Algolia -->
    <template #nav-bar-content-before>
      <BlogSearch />
    </template>
    <!-- 自定义首页 -->
    <template #home-hero-before v-if="isBlogTheme">
      <div class="home">
        <div class="header-banner">
          <BlogHomeBanner />
        </div>
        <div class="content-wrapper">
          <div class="blog-list-wrapper"><blog-list /></div>
          <div class="blog-info-wrapper"><BlogHomeInfo /></div>
        </div>
      </div>
    </template>
    <template #sidebar-nav-after v-if="isBlogTheme">
      <BlogSidebar />
    </template>
    <!-- 评论 -->
    <template #doc-after>
      <BlogComment />
    </template>
  </Layout>
</template>
```

使用到了之前引入的组件，然后将其放入 layout 提供的 slot 中

我们首先关心首页上面那部分，即类 `header-banner`，我会将其放到源代码 4 处

## style 部分

```vue
<style scoped lang="scss">
.home {
  margin: 0 auto;
  padding: 20px;
  max-width: 1126px;
}

@media screen and (min-width: 960px) {
  .home {
    padding-top: var(--vp-nav-height);
  }
}

.header-banner {
  width: 100%;
  padding: 60px 0;
}

.content-wrapper {
  display: flex;
  align-items: flex-start;
  justify-content: center;
}

.blog-list-wrapper {
  width: 100%;
}
.blog-info-wrapper {
  margin-left: 16px;
  position: sticky;
  top: 100px;
}

@media screen and (max-width: 959px) {
  .blog-info-wrapper {
    margin-left: 16px;
    position: sticky;
    top: 40px;
  }
}

@media screen and (max-width: 767px) {
  .content-wrapper {
    flex-wrap: wrap;
  }

  .blog-info-wrapper {
    margin: 20px 0;
    width: 100%;
  }
}
</style>
```
