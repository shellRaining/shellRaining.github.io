---
title: 使用 git-crypt 加密文件
tag:
  - tools
description: 同学，你也不想让别人看到你的账本罢
---

# {{ $frontmatter.title }}

## 动机

最近在学习使用 `beancount`
进行账目管理，虽说是一个纯文本的账目记录软件，但出于保密性，还是只能本机更改，不太方便同步到云端。那么有没有可能在本地进行加密，然后同步到云端呢

完全可以，这里使用 `git-crypt` 进行加密，然后使用 `github` 私有仓库进行同步，可以保证一定的安全性

## 安装

```bash
yay -S git-crypt
```

## 使用

1. 首先确保你有一个 `git` 仓库，如果没有请执行 `git init` 来初始化一个仓库

1. 执行 `git-crypt init` 来初始化加密仓库 (注意，如果你的仓库已经提交了想要加密的文件，那么很遗憾加密是无效的，可以通过清除 git
   记录来解决)

1. 设置想要加密的文件，创建一个 `.gitattributes` 文件，这个文件书写规则和 `.gitignore` 是一样的，只是后面需要加上一点东西。

   然后写入想要加密的文件，例如你想要保护你的所有 `beancount` 账本，那么你可以这样写。但请注意，不要将有关 `git` 的文件 (比如
   `.gitattributes`，`.gitmodules`)加入到加密列表中

   ```bash
    *.beancount filter=git-crypt diff=git-crypt
   ```

1. 使用命令 `git-crypt status` 查看各个文本的加密情况，如果符合预期，就可以提交了，如下文本

   ```bash
   not encrypted: .gitattributes
   not encrypted: .gitignore
       encrypted: 2022/2022-12.beancount
       encrypted: 2022/2022.beancount
       encrypted: 2023/10.beancount
       encrypted: accounts.beancount
       encrypted: main.beancount
   ```

1. 如果想要多端同步，可以通过非对称加密或者对称加密的方式来实现，我这里使用对称加密 (嫌弃 GPG 配置太麻烦，不过以后也许会学习使用)，输入命令
   `git-crypt export-key /path/to/key` 来导出密钥，然后将密钥同步到其他设备，然后执行
   `git-crypt unlock /path/to/key` 来解锁仓库

## 参考

文档官网 [git-crypt](https://www.agwa.name/projects/git-crypt/)
