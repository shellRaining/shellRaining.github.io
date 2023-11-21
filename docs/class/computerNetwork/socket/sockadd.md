---
title: sockaddr 和 sockaddr_in 的区别
tag:
  - QA
---

# {{ $frontmatter.title }}

## 问题描述

学习 C 语言 socket API 的时候，写代码的时候遇到了这一段

```c
    int clientSocket = accept(serverSocket, placeholder, &clientAddrLen);
```

这一段中 `placeholder` 是一个 `sockaddr_in` 类型的指针，但需要的参数是 `sockaddr`
类型的指针，需要一次强制转换，因此想要探索一下这两个结构体之间的关系

## 问题分析

`sockaddr`

```c
struct sockaddr_in {
	__uint8_t       sin_len;
	sa_family_t     sin_family; // uint8_t
	in_port_t       sin_port;   // uint16_t
	struct  in_addr sin_addr;   // uint32_t
	char            sin_zero[8];
};
```

`sin` 的命名就是 `sockaddr_in` 的缩写

```c
struct sockaddr {
	__uint8_t       sa_len;         /* total length */
	sa_family_t     sa_family;      /* [XSI] address family */
	char            sa_data[14];    /* [XSI] addr value (actually smaller or larger) */
};
```

可以看到这两个结构体的长度是相等的，都是十六个字节，他们的开头两个字段都是相同的，不同的只有后面的 port addr 等信息

这样设计保证了 `sockaddr_in` 可以被强制转换为 `sockaddr`，而不会出现数据丢失的情况

之所以这样做是为了方便， `sockaddr` 是一个通用的结构体，但是本身很难赋值，通过强制转换，可以间接方便的赋值 (注: sockaddr_in 只是
IPv4 的结构体，IPv6 与之有很大差别)
