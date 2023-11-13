---
title: VMware 安装 Windows 10
tag:
    - tools
description: 想玩白2，但是切换到 Windows 10 有点麻烦，所以在 VMware 中安装了 Windows 10
---

# {{ $frontmatter.title }}

## 安装 VMware Workstation Pro 17

通过 yay 直接安装

```bash
yay -S vmware-workstation
```

打开后输入序列号 `NZ4RR-FTK5H-H81C1-Q30QH-1V2LA`，然后命令行中进行一些配置

```bash
git clone https://github.com/mkubecek/vmware-host-modules.git
cd vmware-host-modules
git checkout -b 16.2.1 origin/workstation-16.2.1
sudo make
```

如果出现错误，运行下面的命令

```bash
sudo pacman -S linux
sudo reboot
sudo pacman -S linux-headers
```

之后就可以正常运行了，但是还存在一个问题，就是共享文件夹还有拖放文件功能还无法使用，目前暂时没有找到解决方案。
