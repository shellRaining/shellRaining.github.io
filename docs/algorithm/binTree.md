---
title: 二叉树类型题目(总结)
tag:
  - algorithm
description: 算法小抄和随想录中二叉树的玩意，会逐渐补充更难的玩意
---

# {{ $frontmatter.title }}

## 遍历

[144 二叉树的前序遍历](https://leetcode.cn/problems/binary-tree-preorder-traversal/)

[94 二叉树的中序遍历](https://leetcode.cn/problems/binary-tree-inorder-traversal/)

[145 二叉树的后序遍历](https://leetcode.cn/problems/binary-tree-postorder-traversal/)

递归遍历方式就不介绍了，主要是迭代方式

1. 前序遍历因为遍历顺序和获取值顺序相同，所以代码最清晰，只需要将栈内元素 pop 出来然后添加值，接着从右到左添加每个子节点即可（因为栈从右到左 pop）
2. 中序遍历是左中右这样打印，而路过节点的顺序是中左右，所以需要 cur 记录一下，如果 cur 为空，那么说明左侧遍历完成，需要处理中间节点，然后将 cur 设置为 cur.right，具体代码需要记住
3. 只需要改变前序遍历的顺序，然后将结果 reverse 即可
