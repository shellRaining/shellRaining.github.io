---
title: Arch Linux 输入法设置 
tag:
  - dotfiles
description: 在 Arch Linux 中配置雾凇输入法。
---

# {{ $frontmatter.title }}

## 问题

Linux 下我不想使用搜狗输入法，听说雾凇输入法不错，踩坑过程记录一下。

遇到的问题有

1. 终端下无法使用中文输入法
2. 浏览器中无法使用中文输入法

## 解决方案

1. 问题一的根源是终端的问题，alacritty 对中文的支持支持比较好，wezterm 对中文的支持就很不错（这也是我迁移的一个原因）
2. 问题二可以通过配置来解决，参考 [fcitx5](https://wiki.archlinux.org/title/Fcitx5_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))。

解决方案是通过在 `/etc/environment` 中添加下面的代码

```bash
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
```

或者在 `~/.xprofile` 中添加下面的代码

```bash
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
```

## 原理

`/etc/environment` 是系统范围的环境变量配置文件，适用于所有用户和进程，包括非图形用户界面 (non-graphical user interfaces)。

而 `~/.xprofile` 是用户级别的 shell 环境和 X Window 配置文件，只适用于当前用户的图形用户界面 (graphical user interface)。
