---
title: Arch Linux 打开 edge 出现 kdewallet 要求输入密码解决办法
tag:
  - tools
description: 确实是一种不太光彩的“解决方案”
---

# {{ $frontmatter.title }}

## 问题

Linux 不知道为什么，更新以后突然每次开机打开 edge 浏览器要求输入 kdewallet 密码，不输入无法使用自动填充等功能，类似如下的截图

<img width='' src='https://raw.githubusercontent.com/shellRaining/img/main/2307/kdewallet.png'>

## 解决方案

所有的解决方案都能够在 Arch Linux 论坛找到（虽然说中文的文档已经很久没有更新了）

[kdewallet](https://wiki.archlinux.org/title/KDE_Wallet)

### 解决方案一

1. 安装 kdewalletmanager
2. 关闭 kdewallet 子系统

这种方式的缺点是无法再使用 edge 的自动填充功能，也无法看到密码

### 解决方案二

1. 安装 kdewalletmanager
2. 在 kdewallet 中设置新的密码为空

这个方法在上面的链接中也提到了，唯一的风险是安全性
