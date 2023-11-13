---
title: 动态规划学习
tag:
  - algorithm
description: 上 labuladong 课程的时候做的笔记
---

# {{ $frontmatter.title }}

## 递归函数的时间复杂度

递归函数时间复杂度 = 每个递归函数的时间复杂度 \* 递归函数的调用次数

以斐波那契数列为例，递归函数的时间复杂度是 O(1)，递归函数的调用次数是 O(2^n)，所以总的时间复杂度是 O(2^n)

## 动态规划特性和思路和本质

特性:

1. 重叠子问题
2. 递推关系(最关键)
3. 最优子结构

思路:

1. 状态定义(选用什么变量作为状态)
2. 选择(每个状态下可以做出什么选择)
3. 函数定义
4. 设置 base case

本质:

1. 实质上是穷举，只要列出所有可能的状态
2. 所以非常依赖递归操作，而且需要加上缓存，这样已经可以解决问题了，但如果想要优化时间复杂度，就可以自底向上操作，进一步还可能优化空间复杂度

## 动态规划题型

似乎有以下几类

1. 最长递增子序列
2. 0-1 背包问题
3. 最长公共子序列
4. ...(暂时还没归类好)

### 1. 背包问题

题目是 [完全平方数](https://leetcode.cn/problems/perfect-squares/)

因为本质上是穷举，所以可以通过递归来解决，我们这里给出思路

使用记忆化搜索，自顶向下解决问题

```js
function numSquares(n: number): number {
  const choices: number[] = Array.from(
    { length: Math.floor(Math.sqrt(n)) },
    (_, k) => (k + 1) * (k + 1)
  );
  const cache: Map<number, number> = new Map();

  function helper(n: number): number {
    if (n === 0) return 0;
    if (cache.has(n)) return cache.get(n)!;

    let min = Number.MAX_SAFE_INTEGER;
    for (const choice of choices) {
      if (choice > n) break;
      min = Math.min(min, helper(n - choice));
    }

    const result = min + 1;
    cache.set(n, result);
    return result;
  }

  return helper(n);
}
```

使用动态规划。从这里可以看到用了模板，先是找到 choice 和 dp 数组，然后设置 base case，最后通过状态转移方程解决，同时这个代码没有经过优化，如果有需要，可以将 choice 设置到 for 循环内进行判断。

```js
function numSquares(n: number): number {
  const choice: number[] = [];
  for (let i = 1; i * i <= n; i++) {
    choice.push(i * i);
  }
  const dp = Array.from({ length: n + 1 }, () => {
    return n + 1;
  });
  dp[0] = 0;

  for (let i = 0; i <= n; i++) {
    for (let j = 0; j < choice.length; j++) {
      if (i - choice[j] < 0) continue;
      dp[i] = Math.min(dp[i], dp[i - choice[j]] + 1);
    }
  }

  return dp[n];
}
```

这道题是一个背包问题（0-1 背包），

相同点：

1. 背包容量是 n

不同点：

1. 他的每个物品的价值是 1
2. 需要事先将这个问题转化成熟悉的样子（通过最少数量和暴力求解可以思考这个部分）
