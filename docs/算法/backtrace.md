---
title: 回溯法学习
tag:
  - algorithm
description: 学灵神的时候做过总结的题目
---

# {{ $frontmatter.title }}

## 子集型回溯法

<!-- TODO: 这个我暂时还没有搞明白，但是已经知道类似的题目大致的思路是如何了，而且有一个模板可以用来套用。 -->

子集型回溯法可以理解为其中的每个元素都是可以选择或者不选择

这里给出一个模板

```typescript
function func(n: number) {
  const path = [];
  const res = [];

  function dfs(idx: number) {
    if (idx == n) {
      // ...
      return;
    }

    // not select
    inner(idx + 1);

    // select then set and reset
    // ...
    inner(idx + 1);
    // ...
  }

  dfs(0);

  return res;
}
```

### 一个例题，构造指定长度的所有二进制字符串

按照子集型模板套路写下就可以

```typescript
function test(n: number) {
  const path = new Array(n).fill(0);
  const res = [];

  function dfs(idx: number) {
    if (idx == n) {
      res.push(path.slice());
      return;
    }

    dfs(idx + 1);
    path[idx] = 1;
    dfs(idx + 1);
    path[idx] = 0;
  }

  dfs(0);
  return res;
}
```

## 组合型回溯法

## 排列型回溯法
