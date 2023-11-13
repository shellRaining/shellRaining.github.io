---
title: Arch Linux btrfs 磁盘挂载
tag:
  - dotfiles
description: 因为笔记本自带硬盘空间不足，所以买了一个移动硬盘，这里记录一下挂载的过程。
---

# {{ $frontmatter.title }}

大致过程如下

1. 找到移动硬盘的分区路径
2. 格式化分区为某个文件系统
3. 挂载分区到某个目录
4. 设置开机自动挂载
5. 测试是否挂载成功

## 找到移动硬盘的分区路径

```bash
lsblk
```

我这里的输出如下（因为已经挂载了，所以有挂载点）

```bash
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
nvme1n1     259:0    0 476.9G  0 disk
├─nvme1n1p1 259:1    0   100M  0 part /boot/efi
├─nvme1n1p2 259:2    0    16M  0 part
├─nvme1n1p3 259:3    0 355.6G  0 part
├─nvme1n1p4 259:4    0   673M  0 part
├─nvme1n1p5 259:5    0     8G  0 part [SWAP]
└─nvme1n1p6 259:6    0   112G  0 part /home
                                      /
nvme0n1     259:7    0 931.5G  0 disk
└─nvme0n1p1 259:8    0 931.5G  0 part /home/shellraining/Documents
```

## 格式化分区为某个文件系统

```bash
sudo mkfs.btrfs /dev/nvme0n1p1
```

这个命令会打印出是否成功的信息，当然还有其他的方式来检查

```bash
sudo btrfs filesystem show /dev/nvme0n1p1
sudo file -s /dev/nvme0n1p1
```

其中第一个命令的输出如下

```bash
Label: 'newArch' uuid: 21244719-f0d8-4983-9b77-1522a97d567e
Total devices 1 FS bytes used 231.83GiB
devid 1 size 931.51GiB used 283.02GiB path /dev/nvme0n1p1
```

## 挂载分区到某个目录（需要提前创建目录）

```bash
mkdir -p /home/shellraining/Documents
sudo mount -t btrfs /dev/nvme0n1p1 /home/shellraining/Documents
```

## 设置开机自动挂载

```bash
sudo vim /etc/fstab
```

将下面的内容添加到文件中

```bash
/dev/nvme0n1p1 /home/shellraining/Documents btrfs defaults 0 0
```

## 测试是否挂载成功

```bash
df -h
```

其输出样例为

```bash
文件系统        大小  已用  可用 已用% 挂载点
dev             7.6G     0  7.6G    0% /dev
run             7.6G  1.9M  7.6G    1% /run
/dev/nvme1n1p6  113G   93G   18G   85% /
tmpfs           7.6G  111M  7.5G    2% /dev/shm
/dev/nvme1n1p6  113G   93G   18G   85% /home
tmpfs           7.6G   57M  7.5G    1% /tmp
/dev/nvme1n1p1   96M   30M   67M   31% /boot/efi
tmpfs           1.6G  128K  1.6G    1% /run/user/1000
/dev/nvme0n1p1  932G  233G  699G   25% /home/shellraining/Documents
```
