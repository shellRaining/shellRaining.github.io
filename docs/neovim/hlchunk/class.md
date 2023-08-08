---
title: 构造 Lua 中的类
tag:
  - neovim
  - hlchunk
description: 如何才能在 Lua 中近似的实现一个构造函数
---

# {{ $frontmatter.title }}

## 问题

在阅读 `anyline.nvim` 的时候，遇到了类似的写法

```lua
---@class M
---@field a number
---@field b number?
local M = {
	a = 0,
	b = 0,
}

function M:new(a, b)
	local o = {}
	o.a = a
	o.b = b
	setmetatable(o, self)
	return o
end

function M:call()
	print("self.a = " .. self.a .. ", self.b = " .. (self.b or "nil"))
end

M.__index = M
M.__call = M.call

return setmetatable(M, {
	__call = M.new,
})
```

而在另一个文件 `main.lua` 中调用这个模块，可以这样做

```lua
local T = require("table_call")

local t = T(4, 2)
local u = T(3)
t()
u()
```

这样就实现了一个类似于构造函数的效果。

我在读到这个代码的时候有两个地方有疑问

1. 为什么在 `new` 函数中，要在其中的 `o` 中附加 `a` 和 `b` 属性，而不是在 `self` 中附加该属性？
2. 为什么在最后还要设置 `M.__index = M` 和 `M.__call = M.call`，他和最后一段有冲突吗？

## 解答

1. 如果在 `self` 上直接附加属性，上面 `main.lua` 中的 `t` 和 `u` 就会共享 `a` 和 `b` 属性，导致 `T(3)` 这个调用覆盖了上面的 `T(4, 2)` 操作，导致 `t()` 和 `u()` 打印出来的内容是一样的。

2. 最后一段代码实际上实现了模仿构造函数的效果，`__call = M.new` 导致 new 操作会在 `T(4, 2)` 这个调用中被调用，返回了一个新的对象 `o`。

   而 `M.__index` 和 `M.__call` 则是为了给类的实例服务的，如果 new 操作时候没有提供足够的参数，会使用定义这个类时候给出的默认值，`__call` 则保证这个实例也可以作为一个函数直接调用（虽然说没有多大用，但希望你可以分清楚他们之间的区别）。
