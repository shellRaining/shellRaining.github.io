---
title: 使用了 template 标签后没有正常渲染
tag:
  - QA
---

# {{ $frontmatter.title }}

## 问题描述

```vue
<template>
  <h1>components test</h1>
  <div>
    <template v-for="book in books">
      <PropsTest
        :title="book.name"
        :price="book.price"
        :greeting-msg="book.greetingMsg"
        :comments="book.comments"
      ></PropsTest>
    </template>
  </div>
  <template> <ComponentsEvent @notify="show" :msg="msg"></ComponentsEvent> </template>
</template>
```

这段代码中，第一个 `template` 标签中的内容被正常渲染，但是第二个 `template` 标签中的内容没有显示，打开控制台看后显示的只有一个
`#template-fragment` 的提示

## 问题分析

首先找到最小复现代码，首先初始化一个工程，对 `app.vue` 进行修改

```vue
<template>
  <template> <HelloWorld msg="You did it!" /> </template>
  <template> <TheWelcome /> </template>
  <HelloWorld msg="you did it"></HelloWorld>
  <TheWelcome></TheWelcome>
</template>
```

这时候上面两个 `template` 中的内容都不会显示，而下面两个 `HelloWorld` 和 `TheWelcome`
组件都会正常显示，这时候可以确定不是 `Vue` 的特性导致的，只需要关注 template 标签即可

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <link rel="icon" href="/favicon.ico">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vite App</title>
  </head>
  <body>
    hello
    <template>world</template>
  </body>
</html>
```

这就是最终的简化代码，可以看到 `template` 标签中的内容没有被渲染，而且控制台中也有一个 `#template-fragment`
的提示，用此关键词向 `new bing` 提问，最终获得答案

这个标签是用来保存一些 HTML 内容，但不会在页面加载时渲染，而是可以在运行时通过 JavaScript 实例化。

因此，最上面的提问可以有一个初步的解答，我们需要运行时通过 JavaScript 来实例化这个标签中的内容，而第一个标签因为有 `v-for`
语句，所以可以实现，但是第二个没有，所以只能手动实例化

## 解决方案

添加下面的代码

```html
<script>
  // 获取 <template> 元素
  let temp = document.querySelector("template");
  // 克隆 <template> 的内容
  let clon = temp.content.cloneNode(true);
  // 把克隆的内容添加到 body 元素
  document.body.appendChild(clon);
</script>
```

或者在第二个 `template` 标签中添加 `v-if` 语句

<!-- TODO: 渲染机制是什么 -->
