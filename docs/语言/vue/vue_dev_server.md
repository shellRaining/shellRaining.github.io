---
title: Vue 开发时相对路径引入资源出现的问题
tag:
  - QA
---

# {{ $frontmatter.title }}

## 问题描述

下面这段代码，如果单独使用标黄色区域的代码来获取 SVG 图标的路径，最后会在浏览器中报错
`GET http://localhost:5173/icons/volume/slience.svg 404 (Not Found)`，而同时上面的图标却可以正常显示

```vue{33}
<script>
const volume = {
  slience: {
    id: 0,
    src: "./icons/volume/slience.svg",
    alt: "slience",
  },
};

const playerState = ref({
  settings: {
    volume: volume.slience,
    list: false,
  },
});

const volumeSrc = computed(() => {
  return playerState.value.settings.volumeSrc.src; // [!code error]
  const path = new URL(playerState.value.settings.volume.src, import.meta.url); // [!code warning]
  return path.href;
});

const volumeAlt = computed(() => {
  return playerState.value.settings.volume.alt;
});
</script>

<template>
    <div class="player-settings-btn list">
        <img src="./icons/list.svg" alt="list" />
    </div>
    <div class="player-settings-btn volume" @click="toggleVolume">
        <img :src="volumeSrc" :alt="volumeAlt" />
    </div>
</template>

```

<!-- TODO: 和 vite 服务器相关的部分还是不是很清楚 -->

这部分可以看作静态资源引入问题，相关知识点和 vite 有关，可以参考
[vite 资源处理](https://cn.vitejs.dev/guide/assets.html#new-url-url-import-meta-url)，我选用的就是这种方法，处理代码如上

## 相关资源

[在 Stack Overflow 的提问](https://stackoverflow.com/questions/77357409/handle-static-resource-svg-image-in-vue-vite)
