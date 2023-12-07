---
title: 编写一次 miniVue
tag:
  - diary
  - Vue
description: 记录编写 miniVue reactivity 的过程
---

# {{ $frontmatter.title }}

我们使用 `effect` 函数的时候，会传入一个 `ReactiveEffectOptions` 类型的参数，这个类型的定义如下:

```ts
export interface ReactiveEffectOptions {
  scheduler?: (job: ReactiveEffect) => void
  onStop?: () => void
}
```

但是我们在使用的时候，并没有传入这个参数，这是因为 `effect` 函数内部做了一些处理，将 `opts` 对象合并进了特定的 `effect`
对象中，这个对象的定义如下:

```ts
export class ReactiveEffect {
  private _fn: Function;
  public scheduler: Function | undefined;
  public onStop: Function | undefined;
  public deps: Dep[] = [];
  public active = true;

  run() {}
  stop() {}
}
```

合并的过程如下

```ts
if (opts) {
  extend(_effect, opts);
}
```

`extend` 函数实际上就是 `Object.assign` 函数，将 `opts` 对象的属性合并到 `_effect` 对象中

我猜测这样做是为了使构造函数更加简介，在后面使用 `computed` 的时候，我们会单独使用 `ReactiveEffect` 类，我们不需要每次都是传
`opts` 对象
