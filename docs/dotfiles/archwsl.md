---
title: Arch WSL
tag:
  - dotfiles
description: 在 Windows 下面使用 Arch Linux
---

# {{ $frontmatter.title }}

## 安装

首先在 `启用或关闭 Windows 功能` 中启用 `适用于 Linux 的 Windows 子系统`，重启电脑后通过 `PowerShell` 执行这个命令，注意安装时候如果使用 `clash` 需要退出，否则会报网络错误。

```powershell
wsl --update
```

然后安装 `scoop`，在 PowerShell 中执行

```powershell
Set-ExecutionPolicy RemoteSigned -scope CurrentUser # 允许执行脚本
iwr -useb get.scoop.sh | iex
```

使用 scoop 工具进行安装 Arch Linux

```powershell
scoop bucket add extras
scoop install archwsl
```

## 配置

### 修改默认用户

```bash
useradd -m -s /bin/zsh shellraining
passwd shellraining
export EDITOR=vim
visudo
```

在里面添加

```bash
shellraining ALL=(ALL) ALL
```

然后修改 Arch WSL 默认启动用户 `root` 为 `shellRaining`

```bash
arch config --default-user shellRaining
```

### 安装软件

首先注意 WSL 是走的 UWP 应用的网络，所以需要在 `clash` 里面更改一下规则，具体见 clash 用法，不再赘述

然后更新软件源,更新密钥,有关密钥的更多信息可以参考 [Arch Wiki](https://wiki.archlinux.org/index.php/Pacman/Package_signing)

```bash
sudo pacman -S archlinux-keyring
sudo pacman -Syyu
```

:::tip
在安装 tmux 时候遇到了 `NCURSES6_TINFO_6.4.current not found (required by tmux)` 的问题，在使用 `pacman -Syyu` 更新软件源后就可以正常安装了，所以顺序很重要。
:::

在使用 dotbot 快速安装之前，我们需要进行一些准备，需要安装的软件有

- `git` 用于克隆 dotfiles
- `python` 用来执行 dotbot 相关的命令
- `openssh-client` 用于使用 ssh 克隆仓库

```bash
sudo pacman -S git python openssh-client
ssh-keygen -t ed25519 -C "shellRaining@gmail.com"
git clone --recurse-submodules https://github.com/shellRaining/dotfiles.git
```

在 Neovim 安装插件的时候网络可能很不好，可以尝试退出 `clash`

然后安装 dotfiles 中需要的软件

```bash
python archInstall.py
```

### 清理 Windows 环境变量

修改 `/etc/wsl.conf` 文件，添加

```bash
[interop]
appendWindowsPath = false
```

然后在 PowerShell 中执行

```powershell
wsl --terminate arch
```
