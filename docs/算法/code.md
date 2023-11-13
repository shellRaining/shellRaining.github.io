---
title: 编码边界条件
tag:
  - algorithm
description: 编码算法的时候应该注意的边界条件
---

# {{ $frontmatter.title }}

## 链表

[https://leetcode.cn/problems/linked-list-cycle/](https://leetcode.cn/problems/linked-list-cycle/)

比如这道题，需要使用快慢指针，边界条件也许只有这五种

1. 链表为空
2. 链表只有一个节点，且不是环
3. 链表只有一个节点，且是环
4. 链表有两个节点，且不是环
5. 链表有两个节点，且是环

在这里我们首先知道使用双指针，然后再根据边界条件具体来进行判断和编码
