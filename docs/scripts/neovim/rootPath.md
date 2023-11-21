---
title: 使用 Lua 来检查 Neovim 当前 buffer 所在的根目录
tag:
  - script
description: 我从来不愿意写这么多重复的脚本...
---

# {{ $frontmatter.title }}

首先使用 LSP 进行判断，如果没有 LSP 提供的信息，就使用模式匹配来判断

```lua
---@param bufnr number? default is current buffer
---@return string | nil
local function get_root_by_lsp(bufnr)
    bufnr = bufnr or 0
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    if #clients == 0 or not clients[1].config or not clients[1].config.workspace_folders then
        return nil
    end
    return clients[1].config.workspace_folders[1].name
end

---@param bufnr number? default is current buffer
---@return string
function M.get_root(bufnr)
    bufnr = bufnr or 0

    -- get root by lsp
    local root = get_root_by_lsp(bufnr)
    if root then
        return root
    end

    -- get by pattern
    local patterns = {
        ".git",
        ".svn",
        "package.json",
        "Cargo.toml",
        "requirements.txt",
        "Makefile",
        "CMakeLists.txt",
        ".gitignore",
    }
    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == "" then
        path = vim.loop.cwd() --[[@as string]]
    end
    root = vim.fs.find(patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
    return root
end
```

模式匹配部分的思路是，首先判断是不是临时 buffer，如果是，则使用当前目录作为向上查找的目录，反之使用当前 buffer 文件路径作为向上查找的起点

然后使用 `vim.fs.find` 来查找，注意使用了 upward 来表示向上查找，而且返回的是第一个符合条件的路径，但是如果没有找到，则返回一个空的
table，所以需要判断一下

如果还是空 table，就直接使用当前目录作为根路径

## 吐槽

Lua 来写脚本真的是太累了，很多函数都没有，而且每次写都要吟唱很久，千万不要出 nil ...
