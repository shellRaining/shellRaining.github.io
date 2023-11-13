---
title: 计算机网络应用层包设计
tag:
  - diary
description: 记录一些一次应用层涉及和实践
---

# {{ $frontmatter.title }}

这是计算机网络课程中的 lab1，要求使用 socket API 实现客户端和服务器之间的通信，类似于聊天平台的功能。

主要介绍应用层包的设计，主要参考了这篇文章
[https://segmentfault.com/a/1190000008740863](https://segmentfault.com/a/1190000008740863)

## 1. 设计

<img width='' src='https://raw.githubusercontent.com/shellRaining/img/main/2310/packageStruct.png'>

```c
// protoHead.h
enum {
  QUERY_TIME     = 0x01,
  QUERY_NAME     = 0x02,
  QUERY_ACTIVE   = 0x03,
  QUERY_SEND_MSG = 0x04,
  REPLY_TIME     = 0x05,
  REPLY_NAME     = 0x06,
  REPLY_ACTIVE   = 0x07,
  REPLY_SEND_MSG = 0x08,
};

typedef struct _protoHead {
  uint8_t  version;
  uint8_t  magic;
  uint16_t type;
  uint32_t len;
} ProtoHead;

typedef struct _protoPacket {
  ProtoHead head;
  char*     msg;
} ProtoPacket;
```

## 2. 问题

这样设计虽然看似统一了收发双方的包结构，但实际上钉死了他的功能，比如实现功能四的时候，一个客户端想要给另一个客户端发送消息，我们无法指定发送的目标，需要在
msg 字段中额外指定，这样需要客户端和服务器两边都进行代码上的更改，C 语言中这样的操作是很麻烦的，所以这就是缺点。
