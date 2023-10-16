---
title: 半角标点全部替换为全角标点 (markdown 格式下)
tag:
  - diary
description: 记录一下编写这个插件时候的心得和过程
---

# {{ $frontmatter.title }}

## 问题

在 Mac 上使用 `alacritty` + `Neovim` 编写 markdown 文稿的时候，当输入标点时候，会强制转换成半角标点，这对于
markdown 输入是好事，但是对于统一风格则不是很方便， 为了解决这个问题，我打算基于 `treesitter`
实现一个插件，通过语义来判断是否需要替换标点。

```lua
-- 51fc32f72c6533bb56e6a3b3c855274942ac4e0d
local inCodeBlock = function(node)
    local ignoreType = {
        "html_block",
        "code_block",
        "fenced_code_block",
        "atx_heading",
        "..."
    }
    while node do
        if vim.tbl_contains(ignoreType, node:type()) then
            return true
        end
        node = node:parent()
    end

    return false
end
```

最初的实现方式是如上面代码所示的，通过不断判断给定位置到根节点的所有节点类型，如果存在需要排除的 pattern
就返回，这样部分有效，但是对于行内代码块就无法处理了，因为 markdown 是由两个解析器共同进行解析的 (markdown 和
markdown_inline)，即使调用 `descendant_for_range` 找到最小匿名节点类型，调用 `parent` 方法后还是会默认使用
`markdown` 解析器，导致直接获取到 `inline` 类型，无法准确判断代码块。

## 解决方案

通过更换解析器可以解决上述问题

```lua
-- 77df759ac37226c52e38446d6e5fc1408280ec36
    local node = ts.get_parser(0, "markdown_inline"):named_node_for_range({ pos.row, pos.col, pos.row, pos.col })
    if not node then
        return false
    end
    local min_node = node:descendant_for_range(pos.row, pos.col, pos.row, pos.col)
    while min_node do
        if ignore[min_node:type()] then
            res = false
            break
        end
        min_node = min_node:parent()
    end
```

但这样仍有不足，比如标题的逗号不会正常解析，因为这个是由 markdown 解析器进行解析的，所以还需要重复一次上面的操作，保证筛选两次即可。

但这样终究不是优雅的方式，可以通过查看 `indent_blankline` v3 的代码来学习一下 query 式子的用法，然后重构一下代码。
