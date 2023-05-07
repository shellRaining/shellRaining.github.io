---
title: Arch Linux 设置 Fn 键
tag:
  - dotfiles
description: 通过修改 /sys/module/hid_apple/parameters/fnmode 来修改 Fn 键的行为。
---

# {{ $frontmatter.title }}

## 问题

在 Arch Linux 中，我使用的是 Reccazr 无线键盘，但是 Fn 键的行为和我想要的不一样，我想要的是 Fn 键按下时，F1-F12 键的行为是 F1-F12，而不是亮度、音量等功能。

## 解决方案

参照这篇文章 [Arch Linux 设置 Fn 键](https://joydig.com/linux-setup-keyboard-fn-mode/)，

在 Arch Linux 中，可以通过修改 `/sys/module/hid_apple/parameters/fnmode` 来修改 Fn 键的行为。

```bash
echo 2 > /sys/mohttps://joydig.com/linux-setup-keyboard-fn-mode/
```

为了保持开机时自启动，可以在 `/etc/modprobe.d/hid_apple.conf` 中添加一行：

```bash
options hid_apple fnmode=2
```

## 参数解释

- 0: Fn 键默认为 F1-F12
- 1: Fn 键默认为亮度、音量等功能
- 2: Fn 键默认为 F1-F12，但是按下 Fn 键时，F1-F12 键的行为是亮度、音量等功能
