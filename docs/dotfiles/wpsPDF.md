---
title: Arch Linux WPS PDF 无法打开解决方案
tag:
  - dotfiles
description: 在 Arch Linux 中解决 WPS PDF 无法打开的问题。
---

# {{ $frontmatter.title }}

## 问题

在 Arch Linux 中安装 WPS PDF 后，无法打开 PDF 文件，同时无法从 WPS 文字生成 PDF 文件。

出现问题的原因是，WPS PDF 依赖于 `libtiff5`，而 Arch 由于滚动更新的特性，已经升级到了 `libtiff6`，因此 WPS PDF 无法正常工作。同时 aur 中打包的 WPS 也没有将 `libtiff5` 作为依赖，所以会报错。

## 解决方案

通过手动安装 `libtiff5` 来解决这个问题。

```bash
yay -S libtiff5
```

参考 [aur WPS package](https://aur.archlinux.org/pkgbase/wps-office-cn?O=10&PP=10)
