---
title: VirtualBox 安装 Windows 10
tag:
  - tools
description: 想玩白2，但是切换到 Windows 10 有点麻烦，所以在 VirtualBox 中安装了 Windows 10
---

# {{ $frontmatter.title }}

## 安装 VirtualBox

通过 yay 直接安装

```bash
yay -S virtualbox virtualbox-guest-dkms-vmsvga virtualbox-guest-utils virtualbox-host-modules-arch
```

如果也遇到和 VMware 一样的问题，可以参考 [VMware 安装 Windows 10](./VMware) 中的解决方案。

## 安装 Windows 10

准备好镜像后并安装后，需要安装增强功能，这样才能正常使用拖放功能还有共享文件夹功能。下载的地址为 [VirtualBox Guest Additions ISO](http://download.virtualbox.org/virtualbox)，找到合适版本的 ISO，安装到 Windows 虚拟机中。

同时，为了玩白2，还需要安装相关的库，DLL 之类的，为了快速的安装这些东西，可以使用 [AIO runtimes](https://www.computerbase.de/downloads/systemtools/all-in-one-runtimes/)

之后设置共享文件夹，其中选好宿主机路径，设置共享文件夹为 `Game` 然后选择自动挂载，之后就可以在 Windows 中访问了。
