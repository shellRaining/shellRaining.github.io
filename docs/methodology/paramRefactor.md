---
title: 函数默认参数重构
tag:
  - 方法论
description: 写 TypeScript 的时候，如果我们用一个对象 opts 作为参数，并且这个对象内部的属性是可选的，那么我们需要一些操作来设置默认值..
---

# {{ $frontmatter.title }}

写 TypeScript 的时候，如果我们用一个对象 opts 作为参数，并且这个对象内部的属性是可选的，那么我们需要一些操作来设置默认值

## 1. 通过一个 `setOpts` 函数来设置默认值

```ts
const defaultRendererOptions = {
  createElement: document.createElement,
  setElementText: (el: HTMLElement, text: string) => {
    el.textContent = text;
  },
  insert: (child: Node, parent: Node, anchor?: Node) => {
    parent.insertBefore(child, anchor);
  },
};

function setRendererOptions(options: RendererOptions) {
  return Object.assign({}, defaultRendererOptions, options);
}
```

然后在调用的时候， 我们需要这样写

```ts
function createRenderer(opts) {
  const options = setRendererOptions(opts);
}

createRenderer({})
```

## 2. 通过解构赋值来设置默认值

```ts
export function createRenderer({
  createElement = defaultRendererOptions.createElement,
  setElementText = defaultRendererOptions.setElementText,
  insert = defaultRendererOptions.insert,
}: RendererOptions = {}) {
}

createRenderer({})
```

通过比较来说，我还是更喜欢第二种方法，因为更简洁的调用，但是如果 `RendererOptions` 的属性比较多的话，那么第一种方法就更好了
