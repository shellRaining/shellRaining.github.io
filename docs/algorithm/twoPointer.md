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

[2779 数组的最大美丽值](https://leetcode.cn/problems/maximum-beauty-of-an-array-after-applying-operation)

非常棒的一道题，因为我们不能直接从题目中看出使用双指针的痕迹，需要首先自己手动对数组进行排序（当然不是真的看不出来）

因为结果要求最大美丽值，所以一定包含一个子数组，这个子数组的最开始的值和最后一个值相差一定是 2k，然后需要求这个子数组的最长值，从这里可以看出是滑动窗口（或者说双指针）

<!-- TODO: 使用二分解决问题 -->

当然，选这道题不只是因为他是双指针，还因为他可以学到二分相关的知识，因为我们可以用 left 变量进行遍历，通过二分查找（寻找大于 nums[left] + 2k 的第一个值）来找到 right 的位置，从而比较出最长的范围。

[209 长度最小的子数组](https://leetcode-cn.com/problems/minimum-size-subarray-sum/)

这道题主要是用来学习左端点遍历或是右端点遍历。经过测试，右端点遍历和左端点遍历没有明显的性能差异。

1. 当从左端点进行遍历时，我们需要在一次遍历中不断地移动右端点（注意不要超过数组边界），直到满足窗口内的元素和大于等于目标值，此时更新答案（最小长度），然后移动左端点完成此次迭代
2. 当从右端点进行遍历时，同理如上
3. 这道题还需要注意左闭右开或者左闭右闭的问题

[2831 找出最长等值子数组](https://leetcode.cn/problems/find-the-longest-equal-subarray/)

**周赛题目**

本题我可以看出是使用滑动窗口并且加上右端点迭代，但是在比赛过程中妄图通过计算每个区间的众数来判断是否超过滑动窗口的区间范围，因为众数判断是一个 O(n) 的操作，所以最后超时了，而且无法通过其他方法优化，因为窗口中的数字可能增加也可能删除，无法通过变量来记忆使之优化至 O(1)。因此最后采用分别判断每一个数的最大可能范围，然后取他们所有的最大值。

同时还有一个需要注意的点，这次使用滑动窗口不是直接使用的数组下标，而是通过一个数组记忆每个出现值的位置，达到 O(1) 获取位置的效果（亦可使用哈希表），因此在遍历的时候使用的是 pos 数组，这个地方比较重要。

### 链表篇

[141 环形链表](https://leetcode-cn.com/problems/linked-list-cycle/)

[142 环形链表 II](https://leetcode-cn.com/problems/linked-list-cycle-ii/)

[160 相交链表](https://leetcode.cn/problems/intersection-of-two-linked-lists/)

[876 链表的中间节点](https://leetcode.cn/problems/middle-of-the-linked-list/)

环形链表主要是使用了快慢指针，通过快指针二倍速于满指针的方式来判断最终是否有相交部分，相交链表也可以通过环形链表进行转化

这个不是很难，但是需要注意编码方式，注意各种临界点，比如给出了 null 节点作为参数，给出一个节点，两个节点时，分别成环，不成环这五种情况，所以最好先在纸上模拟一遍答案。

[19 删除链表的倒数第 N 个结点](https://leetcode-cn.com/problems/remove-nth-node-from-end-of-list/)

[21 合并两个有序列表](https://leetcode-cn.com/problems/merge-two-sorted-lists/)

[23 合并 K 个升序链表](https://leetcode-cn.com/problems/merge-k-sorted-lists/)

[86 分隔链表](https://leetcode-cn.com/problems/partition-list/)

上面这几道题都类似于数组的双指针了，不过多解释。
