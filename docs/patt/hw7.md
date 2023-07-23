---
title: Homework 7
tag:
  - patt
description: introduction to computer systems Homework 7
---

# {{ $frontmatter.title }}

## 9.2

> Why is a ready bit not needed if synchronous I/O is used?

if the I/O is synchronous, the CPU will know when and what device will store or output infomation, which means the CPU not need to check whether the device is ready, just provide service at specfied time

## 9.6

> What problem could occur if a program does not check the ready bit of
> the KBSR before reading the KBDR?

the data is out of date, which means not correct, the data we wanted is not ready

## 9.10

> What problem could occur if the display hardware does not check the
> DSR before writing to the DDR?

the displayed right data was be covered by wrong data

## 9.14

> An LC-3 Load instruction specifies the address xFE02. How do we know
> whether to load from the KBDR or from memory location xFE02?

if KBSR is 1, we load from KBDR, else we load from memory location xFE02

## 9.26

> The following program is supposed to print the number 5 on the screen.
> It does not work. Why? Answer in no more than ten words, please.

the r7 was overwritten when call B
