---
title: 雾凇拼音安装
tag:
    - dotfiles
description: 因为 Mac上自带的输入法实在是太烂了，所以我切换到了 Rime + 雾凇拼音的方案
---

# {{ $frontmatter.title }}

分为两个部分

1. 安装 Rime
2. 安装 雾凇拼音

## 安装 Rime

Mac 下直接使用 brew 安装即可

```bash
brew install --cask squirrel
```

## 安装 雾凇拼音

```bash
cd ~/Library/
mv Rime Rime.bak
git clone git@github.com:iDvel/rime-ice.git Rime
```

然后重新部署即可
