---
title: luaunit 使用
tag:
  - tools
description: 使用这个 Lua 测试框架来进行插件的测试
---

# {{ $frontmatter.title }}

## 安装

通过 `luarocks` 安装，或者直接下载源码

```bash
luarocks install luaunit
```

```bash
git clone git@github.com:bluebird75/luaunit.git
cp luaunit/luaunit.lua lib/path/in/your/project
```

## 初次使用

首先创建一个测试文件，比如 `test_spec.lua`

```lua
local lu = require('luaunit')

os.exit( lu.LuaUnit.run() )
```

然后使用 `lua test_spec.lua` 运行测试，可以看到下面的输出

```
Ran 0 tests in 0.000 seconds, 0 successes, 0 failures
OK
```

然后引入测试用例，在上面代码的中间添加下面的测试函数

```lua
function test_add()
    lu.assertEquals( 1+1, 2 )
end
```

然后就是多个功能点测试用例的情况，我们使用类似 `TestGroup` 的功能

```lua
TestGroup = {}

function TestGroup:test_add()
    lu.assertEquals( 1+1, 2 )
end

function TestGroup:test_sub()
    lu.assertEquals( 1-1, 0 )
end
```

:::warning

注意，其中测试函数需要用 `test` 开头，测试组需要用 `Test` 开头

:::

## 常用测试函数

### 相等性测试

1. `assertEquals(a, b)` 比较两个值是否相等，如果 `a` 和 `b` 都是表格，则会递归比较

### 类型测试

1. `assertIsNumber(x)` 判断 `x` 是否是数字
1. `assertIsString(x)` 判断 `x` 是否是字符串
1. `assertIsTable(x)` 判断 `x` 是否是表
1. `assertIsFunction(x)` 判断 `x` 是否是函数
1. `assertIsBoolean(x)` 判断 `x` 是否是布尔值
1. `assertIsNil(x)` 判断 `x` 是否是 `nil`

### 规整输出

1. `prettystr(x)` 其中 `x` 可以是任意类型，返回一个字符串，用于打印输出
