---
title: Rust 猜数字程序 Bug
tag:
    - Rust
description: Rust 初体验时候的 Bug
---

# {{ $frontmatter.title }}

具有纪念意义的文章，首次学习 Rust

## 问题描述

```rust
use std::{cmp::Ordering, io};

use rand::Rng;

fn main() {
    let mut guess = String::new();
    let rand_num = rand::thread_rng().gen_range(1..=100);

    loop {
        io::stdin()
            .read_line(&mut guess)
            .expect("please type a number");
        println!("your put is {}", guess);
        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(err) => {
                println!("please type a number");
                continue;
            }
        };

        match guess.cmp(&rand_num) {
            // ...
        }
    }
}
```

当第二次和之后输入数字时，将会出现 `please type a number`

## 问题分析

将 guess 的内容从命令行中打印出来的时候，发现第二次没有成功接受用户输入，打印出来的

```txt {6-7}
please input your guess number
30
your put is 30
too big
please input your guess number
54
your put is 30
54
please type a number
error: invalid digit found in string
please input your guess number
```

可以看到第二次输入数据没有变，这是因为 `let mut guess = String::new();` 只会创建一个新的 guess，第二次输入的时候，guess 里面的内容还是第一次输入的内容，所以会出现 `please type a number` 的错误

## 解决方案

将 `let mut guess = String::new();` 放到 loop 里面，每次都重新创建一个新的 guess

```rust
use std::{cmp::Ordering, io};

use rand::Rng;

fn main() {
    let rand_num = rand::thread_rng().gen_range(1..=100);
    let mut guess = String::new(); // [!code --]

    loop {
        let mut guess = String::new(); // [!code ++]
        io::stdin()
            .read_line(&mut guess)
            .expect("please type a number");
        println!("your put is {}", guess);
        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(err) => {
                println!("please type a number");
                continue;
            }
        };

        match guess.cmp(&rand_num) {
            // ...
        }
    }
}
```
