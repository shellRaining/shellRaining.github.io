---
title: mdformat
tag:
  - tools
description: markdown 格式化另一力作~
---

# {{ $frontmatter.title }}

## 痛点介绍

之前一直使用 prettier 来格式化 markdown，但是发现它支持的玩意太广泛了，而且可自定义性不足，所以改换其他工具，即本章节介绍的 mdformat

## 安装

```bash
pip install mdformat-gfm mdformat-frontmatter mdformat-footnote
```

因为 GitHub 默认支持使用 front-matter，所以需要安装 `mdformat-frontmatter` 插件来支持 front-matter
语法

## 配置

mdformat 使用的是 TOML
作为配置文件,至于可自定义项请参考[官方文档](https://mdformat.readthedocs.io/en/stable/users/configuration_file.html)

## Neovim 支持

请不要使用 Mason 内置的 mdformat 插件，因为它不支持 front-matter，所以请自行下载,然后通过 null-ls 来支持

```lua
M.null_ls.builtins.formatting.mdformat,
```
