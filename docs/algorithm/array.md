---
title: 数组类型的题目(总结)
tag:
  - algorithm
description: 这几周尝试刷了数组的二十几道题, 看看能不能总结出一些经验
---

# {{ $frontmatter.title }}

## 双指针

双指针有两种,一种是相向而行,另一种是同向而行,前者主要是用来求取最大值类型的题目,后者暂不清楚,他的另一种名字又叫作滑动窗口,二者的时间复杂度都是 n 级别的,适合处理六个数量级的数据

<!-- TODO: 滑动窗口 -->

### 相向而行

有道题目用来求如何才能盛最多的水,代码是非常标准的双指针,就放在这里了

```TypeScript
function maxArea(height: number[]): number {
  const len = height.length;
  let i = 0;
  let j = len - 1;
  let cur_max = 0;

  function getArea(l: number, r: number) {
    return (r - l) * Math.min(height[l], height[r]);
  }

  while (i < j) {
    const area = getArea(i, j);
    if (area > cur_max) {
      cur_max = area;
    }

    height[i] < height[j] ? i++ : j--;
  }

  return cur_max;
}
```

唯独难受的是正确性证明,就是为什么要这样写,为什么每次都选择较小的
