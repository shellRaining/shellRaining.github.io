---
title: beancount fava 精度问题
tag:
  - beancount
  - QA
description: 记录 beancount 和 fava 之间的精度问题
---

# {{ $frontmatter.title }}

今天使用 `beancount` 记账的时候，遇到了 fava 显示的余额和实际余额不一致的问题，经过排查，发现是 `fava` 自身计算的精度问题

当时的断言如下

```beancount
2023-11-16 balance Assets:BOC                       650.79 CNY
2023-11-16 balance Assets:ICBC                        0.00 CNY
2023-11-16 balance Assets:Cash                      405.00 CNY
2023-11-16 balance Assets:Receivable:DengJianWen      0.00 CNY
```

但是当时 `fava` 显示如下

<img src='https://raw.githubusercontent.com/shellRaining/img/main/2311/fava.jpg'>

经过手动计算以后，发现正确结果就是 `650.79`，但是 `fava` 显示的是 `650.78`，所以只可能是 `fava` 计算的问题

## 经验

所以不要老开着你那个破 `fava` 进程了，又占地方又不准确 (

每隔三五日进行一次断言即可
