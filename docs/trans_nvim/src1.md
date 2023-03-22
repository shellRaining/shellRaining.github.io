---
title: Trans.nvim 源码分析
tag:
  - nvim-plugin
description: 新了解到一个很好的 nvim 翻译插件，在这里做一些源码分析的工作
---

# Trans.nvim 源码分析

目录结构如下

```
.
├── lua
│   └── Trans
│       ├── backend
│       │   ├── baidu.lua
│       │   ├── offline.lua
│       │   └── youdao.lua
│       ├── core
│       │   ├── backend.lua
│       │   ├── buffer.lua
│       │   ├── conf.lua
│       │   ├── curl.lua
│       │   ├── data.lua
│       │   ├── frontend.lua
│       │   ├── install.lua
│       │   ├── setup.lua
│       │   ├── translate.lua
│       │   ├── util.lua
│       │   └── window.lua
│       ├── frontend
│       │   ├── float.lua
│       │   └── hover
│       │       ├── execute.lua
│       │       ├── init.lua
│       │       ├── load.lua
│       │       ├── offline.lua
│       │       └── youdao.lua
│       ├── health.lua
│       ├── init.lua
│       ├── style
│       │   ├── spinner.lua
│       │   └── theme.lua
│       └── util
│           ├── base64.lua
│           ├── bing_node.lua
│           ├── init.lua
│           ├── md5.lua
│           └── node.lua
├── plugin
│   └── Trans.lua
├── theme
│   ├── default.png
│   ├── dracula.png
│   └── tokyonight.png
└── tts
    ├── package.json
    └── say.js
```

首先插件是从 plugin 目录自动加载的，然后通过在执行其下的 `Trans.lua` 时间接的调用 `lua/Trans/init.lua`，进而启动整个插件。我将会按照这个顺序，自顶向下的介绍这个插件的实现过程

此次分析分支为 `experimental`，提交 SHA 为 `461e680b36691d48bf4761792b8323f64bdaa570`

## plugin/Trans.lua

```lua
local api, fn = vim.api, vim.fn

string.width = api.nvim_strwidth

--- INFO :Define string play method
if fn.has("linux") == 1 then
    string.play = function(self)
        local cmd = ([[echo "%s" | festival --tts]]):format(self)
        fn.jobstart(cmd)
    end
elseif fn.has("mac") == 1 then
    string.play = function(self)
        local cmd = ([[say "%s"]]):format(self)
        fn.jobstart(cmd)
    end
else
    string.play = function(self)
        local separator = fn.has("unix") and "/" or "\\"
        local file = debug.getinfo(1, "S").source:sub(2):match("(.*)lua") .. separator .. "tts" .. separator .. "say.js"
        fn.jobstart("node " .. file .. " " .. self)
    end
end
```

此段部分首先为 neovim 内置的变量命名，然后对 lua 内置的 string 库注入了一些新的方法

- width
- play

width 是用来获取一段字符的长度，不过为什么要使用 neovim 内置操作而不是 lua 的 `#` 运算符呢，因为 lua 内置字符串处理方式是基于 char，而 neovim 是基于 unicode，所以会导致比方说一些汉字和 nerdfont 对齐出现错误

play 操作是用来播放一段文本的方法，在这里根据操作系统的不同使用了不同的定义，比方说 mac 系统下使用了系统内置的 say 操作

```lua
--- INFO :Define plugin command
local Trans = require("Trans")
local command = api.nvim_create_user_command

command("Translate", function()
    Trans.translate()
end, { desc = "单词翻译" })
command("TransPlay", function()
    local str = Trans.util.get_str(api.nvim_get_mode().mode)
    if str and str ~= "" and Trans.util.is_English(str) then
        str:play()
    end
end, { desc = "自动发音" })
```

在这里首先引入了 Trans 库，然后定义了两个 usercmd

- Translate
- TransPlay

其中 translate 将会调用 Trans 库中的 translate 函数，TransPlay 函数会首先获取指定的字符串，然后判断字符串是否存在且不为空且为英语，如果是则对其进行播放操作

## Trans/init.lua

```lua
local function metatable(folder_name, origin)
    return setmetatable(origin or {}, {
        __index = function(tbl, key)
            local status, result = pcall(require, ("Trans.%s.%s"):format(folder_name, key))
            if status then
                tbl[key] = result
                return result
            end
        end,
    })
end

local M = metatable("core", {
    style = metatable("style"),
    cache = {},
    modes = {
        "normal",
        "visual",
        "input",
    },
    augroup = vim.api.nvim_create_augroup("Trans", { clear = true }),
})

M.metatable = metatable

return M
```

这个文件实际上定义了一个包，包内含有一个函数，还有其他很多属性。

代码开始首先定义了一个函数 `metatable` ，这个函数会给你指定的表设置一个 metatable，这个 metatable 不是简单的表，而是一个函数。当你想要查找的属性不存在于原表时，他将会调用这个函数，从指定的路径引入相应的包，并且将其设置为原表的属性，并最终返回查找的属性。相当于进行了一次懒加载和缓存，能够提高代码性能

然后调用上面定义的函数，最后返回这个包，这个包被调用的地方有，usercmd，还有……

## core/translate.lua

这是本插件核心代码，用户输入命令后便会执行这里提供的函数，调用方式如下

```lua
-- plugin/Trans.lua
command("Translate", function()
    Trans.translate()
end, { desc = "单词翻译" })
```

其源代码如下

```lua
local Trans = require('Trans')
local util = Trans.util

local function init_opts(opts)
    opts = opts or {}
    opts.mode = opts.mode or ({
        n = 'normal',
        v = 'visual',
    })[vim.api.nvim_get_mode().mode]

    opts.str = util.get_str(opts.mode)
    return opts
end


---@type table<string, fun(data: TransData): true | nil>
local strategy = {
    fallback = function(data)
        local result = data.result
        Trans.backend.offline.query(data)
        if result.offline then return true end


        local update = data.frontend:wait()
        for _, backend in ipairs(data.backends) do
            ---@cast backend TransBackend
            backend.query(data)
            local name = backend.name

            while result[name] == nil do
                if not update() then return end
            end

            if result[name] then return true end
        end
    end,
    --- TODO :More Strategys
}


-- HACK : Core process logic
local function process(opts)
    opts = init_opts(opts)
    local str = opts.str
    if not str or str == '' then return end

    -- Find in cache
    if Trans.cache[str] then
        local data = Trans.cache[str]
        data.frontend:process(data)
        return
    end

    local data = Trans.data.new(opts)
    if strategy[Trans.conf.query](data) then
        Trans.cache[data.str] = data
        data.frontend:process(data)

    else
        data.frontend:fallback()
    end
end


---@class Trans
---@field translate fun(opts: { frontend: string?, mode: string?}?) Translate string core function
return function(opts)
    coroutine.wrap(process)(opts)
end
```
