---
title: 在 Neovim 中使用 ChatGPT.nvim
tag:
  - neovim
description: 通过 ChatGPT.nvim 插件，实现在 Neovim 中集成 AI 功能
---

# {{ $frontmatter.title }}

## 配置

例如我使用的是 `openai-sb` 的代理,所以我需要更改我的配置中的 `api_host_cmd` 为 `echo api.openai-sb.com`

还有就是密钥的配置,设置 `api_key_cmd` 为 `echo $OPENAI_API_KEY`
即可,但是需要注意环境变量是不安全的,因此建议通过一些其他的加密手段,比如密码管理器来进行管理

## 使用

通过一些快捷键进行使用,因为这个文件比较重要,所以我没有上传到 GitHub,配置就放在这里好了

```lua
function M.after()
    map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>cc",
            rhs = "<cmd>ChatGPT<cr>",
            options = { silent = true, expr = true },
            description = "ChatGPT",
        },
        {
            mode = { "n" },
            lhs = "<leader>ci",
            rhs = "<cmd>ChatGPTEditWithInstruction<cr>",
            options = { silent = true, expr = true },
            description = "ChatGPT Edit with instruction",
        },
        {
            mode = { "n" },
            lhs = "<leader>ct",
            rhs = "<cmd>ChatGPTRun add_tests<cr>",
            options = { silent = true, expr = true },
            description = "ChatGPT add tests",
        },
        {
            mode = { "n" },
            lhs = "<leader>co",
            rhs = "<cmd>ChatGPTRun optimize_code<cr>",
            options = { silent = true, expr = true },
            description = "ChatGPT optimize code",
        },
    })
end
```
