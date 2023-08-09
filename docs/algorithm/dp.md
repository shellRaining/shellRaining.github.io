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

题目是 [完全平方数](https://leetcode.cn/problems/perfect-squares/?envType=study-plan-v2&envId=dynamic-programming)

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

从这里可以看到用了模板，先是找到 choice 和 dp 数组，然后设置 base case，最后通过状态转移方程解决，同时这个代码没有经过优化，如果有需要，可以将 choice 设置到 for 循环内进行判断。

<!-- TODO: add something -->
