---
title: vim.validate 函数
tag:
  - neovim
  - func_intro
description: 介绍 vim.validate 函数
---

# {{ $frontmatter.title }}

## 介绍

在 `mini-indentscope` 插件中，有这么一段代码

```lua
H.setup_config = function(config)
    -- General idea: if some table elements are not present in user-supplied
    -- `config`, take them from default config
    vim.validate({ config = { config, "table", true } })
    config = vim.tbl_deep_extend("force", H.default_config, config or {})
    -- ...
end
```

在这里用到了 `vim.validate` 函数。用法如下

接收一个表作为参数，表中的每个键值对中，键是要验证的值，值是验证规则。规则的格式有两种

1. `{ value, type, optional }`，其中 `value` 是要验证的值，`type` 是要验证的类型，`optional` 是是否可以为 nil。

2. `{ value, fn, msg }`，其中 `value` 是要验证的值，`fn` 是验证函数，`msg` 是验证失败时的错误信息。

一般来说 key（验证值）应该同名，但我没有测试过特殊情况。

返回值没有提到，应该为 nil，如果成功验证，无返回，反之会爆错误信息。

例子如下：

```lua
vim.validate{arg1={{'foo'}, 'table'}, arg2={'foo', 'string'}}
 --> NOP (success)

vim.validate{arg1={1, 'table'}}
 --> error('arg1: expected table, got number')

vim.validate{arg1={3, function(a) return (a % 2) == 0 end, 'even number'}}
 --> error('arg1: expected even number, got 3')

If multiple types are valid they can be given as a list. >lua

vim.validate{arg1={{'foo'}, {'table', 'string'}}, arg2={'foo', {'table', 'string'}}}
 --> NOP (success)

vim.validate{arg1={1, {'string', 'table'}}}
 --> error('arg1: expected string|table, got number')
```

## 思考

这种验证方式我只看到了用来验证参数类型的功能，但为什么不使用更加方便和直观和强大的 luals 注释来进行预防呢。
