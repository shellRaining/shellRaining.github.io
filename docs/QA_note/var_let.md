---
title: var 和 let 声明变量的区别
tag:
  - QA
---

# {{ $frontmatter.title }}

## 问题描述

```ts
var a = 10;
function func() {
  console.log(a);
  var a = 20;
}
```

上面这段代码为什么会输出 `undefined` 而不是 `10` 呢？

```ts
var a = 10;
function func() {
  console.log(a);
  let a = 20;
}
```

上面这段代码为什么会报错呢？

## 问题分析

打印 undefined 是因为 var 导致变量 a 的声明被提升到函数最开始的位置，此时还没有赋值，所以是 undefined。

报出 ReferenceError 错误，因为 a 变量也被提升了，但是暂时性死区导致在这个声明之前的引用会报错 (可以视为没有提升)。

总结一下他们的区别

1. 作用域: var 声明的变量作用域是函数作用域，let 声明的变量作用域是块级作用域
2. 重复声明: var 可以重复声明，let 不可以重复声明

```ts
var a = 10;
var a;
console.log(a); // 10
```

3. 变量提升: var 声明的变量会被提升到函数作用域的最开始，let 声明的变量也会被提升，但是会暂时性死区

## 参考资料

[https://juejin.cn/post/6844904050614353928](https://juejin.cn/post/6844904050614353928)
