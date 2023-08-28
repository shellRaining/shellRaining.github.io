---
title: 双指针类型题目(总结)
tag:
  - algorithm
description: 算法小抄中双指针的题目，逐渐补充更难的题目
---

# {{ $frontmatter.title }}

[学习链接](https://labuladong.github.io/algo/di-ling-zh-bfe1b/shuang-zhi-fa4bd/)

双指针类型的题目是数组和链表类型题目的一部分，一般使用的场景是当数组或者链表有一定顺序或者结构，比如增序排列或者回文字符串等，如果是从左到右的顺序，使用快慢指针，如果是两侧到中间的题目，使用左右两侧指针的方式就可以。

## 例题

### 数组篇

[167 两数之和(输入有序数组)](https://leetcode.cn/problems/two-sum-ii-input-array-is-sorted/)

[26 移除重复数组元素](https://leetcode-cn.com/problems/remove-duplicates-from-sorted-array/)

[27 移除元素](https://leetcode-cn.com/problems/remove-element/)

[283 移除元素 0](https://leetcode-cn.com/problems/move-zeroes/)

这四道题目都是从左到右使用双指针来解决的，我在这里想要提一下在什么时候会移动左侧的慢指针，26 题是当快指针和慢指针的值不相等的时候，27 题是当快指针的值不等于目标值的时候。

还有一个有意思的点，就是是应该先赋值还是应该先步进。其实这很简单，我们使用双指针就是为了节约空间(在节省时间的同时)，所以大多数时候都是在原数组或者原字符串进行操作，可以假设为我们开辟了新的数组，这时候移除重复元素就需要和新数组的尾部元素进行比较，此时便是先步进再赋值，而移除元素则是没有这个顾虑，可以先赋值再步进。

[844 比较含退格的字符串](https://leetcode-cn.com/problems/backspace-string-compare/)

这道题和之前的几道都不一样，因为他的双指针是针对两个字符串的，而前面的题目都是在同一个对象上进行操作，同时这道题还是从右向左进行遍历，值得一看

[977 有序数组的平方](https://leetcode-cn.com/problems/squares-of-a-sorted-array/)

这道题目有点意思，因为他是从中间到两边进行遍历排序的，很类似归并排序，而且不要忘记当一个指针到达边界后，另一个指针可能还没有处理完，循环结束，我们还需要另一个循环来处理剩下的内容。

### 链表篇

[141 环形链表](https://leetcode-cn.com/problems/linked-list-cycle/)

[142 环形链表 II](https://leetcode-cn.com/problems/linked-list-cycle-ii/)

[202 快乐数](https://leetcode-cn.com/problems/happy-number/)

[876 链表的中间结点](https://leetcode-cn.com/problems/middle-of-the-linked-list/)

[19 删除链表的倒数第 N 个结点](https://leetcode-cn.com/problems/remove-nth-node-from-end-of-list/)

[61 旋转链表](https://leetcode-cn.com/problems/rotate-list/)

[234 回文链表](https://leetcode-cn.com/problems/palindrome-linked-list/)

[143 重排链表](https://leetcode-cn.com/problems/reorder-list/)

[25 K 个一组翻转链表](https://leetcode-cn.com/problems/reverse-nodes-in-k-group/)
