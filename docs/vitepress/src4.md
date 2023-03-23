---
title: 阅读 sugar theme 源代码4（源代码 BlogHomeBanner.vue）
tag:
  - vitepress
description: 本站使用的主题就是 sugar，但是和我的目标不符合，所以希望阅读源码并修改，此处为第一步：阅读源码
---

# {{ $frontmatter.title }}

## template 部分

```vue
<!-- <template> -->
<!--   <div> -->
<!--     <h1> // [!code focus]  -->
<!--       <span class="name">{{ name }}</span> // [!code focus] -->
<!--       <span class="motto" v-show="motto">{{ motto }}</span> // [!code focus] -->
<!--     </h1> // [!code focus] -->
<!--     <div class="inspiring-wrapper"> // [!code focus] -->
<!--       <h2 @click="changeSlogan" v-show="!!inspiring">{{ inspiring }}</h2> // [!code focus] -->
<!--     </div> // [!code focus] -->
<!--   </div> -->
<!-- </template> -->
```

首先看 h1 部分，由两个 span 组成，分别为名称和座右铭，其中座右铭还使用了 v-show 语法来表示是否显示

:::info
`v-show` 和 `v-if` 都是 Vue.js 中的指令，用于控制组件或元素的显示或隐藏。它们的区别在于：

`v-show` 是通过 CSS 的 display 属性来控制元素的显示或隐藏，而 `v-if` 是通过将元素插入或删除 DOM 来控制元素的显示或隐藏。因此，当使用 v-show 隐藏元素时，该元素仍然存在于 DOM 中，只是其 CSS 的 display 属性被设置为 none；而当使用 v-if 隐藏元素时，该元素会被从 DOM 中移除，下次重新渲染时需要重新创建。

由于 v-show 只是设置 CSS 属性，因此在初始渲染时会比 v-if 更快，但是在频繁切换显示和隐藏时，会影响页面的性能。而 v-if 在初始渲染时会根据表达式的值决定是否渲染元素，因此在频繁切换时，会比 v-show 更快。

由于 v-show 只是设置 CSS 属性，因此它可以应用于任何元素，而 v-if 只能应用于带有条件的元素。
:::

然后看 div 部分，这部分也使用了 v-show，不过先是使用感叹号将 inspiring 强行转化为了 bool 类型，其中还绑定了一个点击事件，用来执行切换 slogan 的操作

## script 部分

```vue
<script setup lang="ts">
import { computed, ref } from "vue";
import { useData } from "vitepress";
import { useHomeConfig, useBlogConfig } from "../composables/config/blog";

const { site, frontmatter } = useData();
const { home } = useBlogConfig();

const name = computed(
  () => (frontmatter.value.blog?.name ?? site.value.title) || home?.name || ""
);
const motto = computed(
  () => frontmatter.value.blog?.motto || home?.motto || ""
);
const initInspiring = ref<string>(
  frontmatter.value.blog?.inspiring || home?.inspiring || ""
);
const inspiring = computed({
  get() {
    return initInspiring.value;
  },
  set(newValue) {
    initInspiring.value = newValue;
  },
});

const homeConfig = useHomeConfig();

const changeSlogan = async () => {
  if (typeof homeConfig?.handleChangeSlogan !== "function") {
    return;
  }
  const newSlogan = await homeConfig.handleChangeSlogan(inspiring.value);
  if (typeof newSlogan !== "string" || !newSlogan.trim()) {
    return;
  }

  // 重新渲染数据，同时触发动画
  inspiring.value = "";
  setTimeout(async () => {
    inspiring.value = newSlogan;
  });
};
</script>
```

导入部分我们就不看了，从这段代码开始讲起

```typescript
const name = computed(
  () => (frontmatter.value.blog?.name ?? site.value.title) || home?.name || ""
);
const motto = computed(
  () => frontmatter.value.blog?.motto || home?.motto || ""
);
const initInspiring = ref<string>(
  frontmatter.value.blog?.inspiring || home?.inspiring || ""
);
const inspiring = computed({
  get() {
    return initInspiring.value;
  },
  set(newValue) {
    initInspiring.value = newValue;
  },
});
```

我们可以看到从引入的 frontmatter 中我们首先获取 blog 信息，包括 name，motto 等，如果不存在我们就设置为空字符串。

在这里说一下如何使用 useData API，首先说一下这个函数的作用，他是用来获取特定页面的信息，返回类型是 `VitePressData<T = any>`，具体的接口定义如下

```typescript
interface VitePressData<T = any> {
  site: Ref<SiteData<T>>;
  theme: Ref<T>;
  page: Ref<PageData>;
  frontmatter: Ref<PageData["frontmatter"]>;
  params: Ref<PageData["params"]>;
  title: Ref<string>;
  description: Ref<string>;
  lang: Ref<string>;
  isDark: Ref<boolean>;
  dir: Ref<string>;
  localeIndex: Ref<string>;
}

interface PageData {
  title: string;
  titleTemplate?: string | boolean;
  description: string;
  relativePath: string;
  headers: Header[];
  frontmatter: Record<string, any>;
  params?: Record<string, any>;
  isNotFound?: boolean;
  lastUpdated?: number;
}
```

我们先是获取了 VitePressData 中的 frontmatter 属性（这个属性是一个响应式 Ref 属性），然后利用其获取页面的元数据（包括 name，motto，inspiring），即 markdown 文件中的 yaml 部分，如果存在 blog 属性则获取他的具体值，否则返回空串

然后定义了一个 inspiring 变量，可以视为一个具有响应性的对象，这个对象设置了内部属性 get 和 set 函数来用供 computed 使用

:::warning
这个里面使用的不是对象内部访问器属性，而是 computed 的语法
:::

:::info
对象内部属性可以理解为属性的属性，刻画了对象某个属性所带有的特性，一共有两大类共六种，分别是

- 数据属性
  - Configurable （表示是否可以通过 delete 删除并重新定义）
  - Enumerable （表示是否可以通过 for of 循环枚举）
  - Writable （表示值是否可以修改）
  - Value （表示实际的值）
- 访问器属性
  - getter
  - setter

设置他们没有语法糖可以使用，必须使用 Object 的静态方法 defineProperty

:::

## style 部分
