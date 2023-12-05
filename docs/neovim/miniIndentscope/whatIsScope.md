---
title: mini.indentscope 的 Scope
tag:
  - neovim
  - mini.indentscope
description: 主要介绍了 mini.indentscope 中的 Scope 是什么，还有任何计算 Scope 的方法
---

# {{ $frontmatter.title }}

## Scope 是什么

`Scope` 是一组连续的行，他通过一个参考行，一个参考列，还有用户给出的特定 `opts` 来计算

这组行的特点是，其中的每一行缩进都大于等于参考行的缩进，(注意，如果使用 `indent_at_cursor`
选项，参考列会变成给出的参考列和光标所在列的最小值)

## Scope 的计算方法

1. 首先计算一行的缩进

计算缩进有两种情况，一种是该行缩进不为 0，那么直接返回本身的缩进即可，使用 `vim.fn.indent()` 函数很容易做到这一点，当缩进为 0
的时候，我们根据上下文来计算该行的缩进了，具体在这里介绍一下

首先从该行开始，向上和向下分别寻找第一个缩进不为 0 的行，如果找到了，那么就返回该行的缩进，通过 `vim.fn.prevnonblank()` 和
`vim.fn.nextnonblank()`
函数可以做到这一点，然后计算找到的这两行的缩进，再根据这两行的缩进，使用用户给出的缩进策略来计算该行的缩进，用户可以通过 `opts.border`
来选定四种策略的一个

1. `none`
1. `top`
1. `bottom`
1. `both`

如果是 `none` 就选择两行中缩进最小的那个，如果是 `top` 就选择上面的那个，如果是 `bottom` 就选择下面的那个，如果是 `both`
就选择最大的那个，用例如下

```:line-numbers
1
  2
    3

  4
```

第四行的缩进如果选择 `top` 策略，那么就是 4，如果使用的是 `both`，那么也是 4，计算方法就是这样
