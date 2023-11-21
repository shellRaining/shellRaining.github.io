---
title: Homework 5
tag:
  - patt
description: introduction to computer systems Homework 5
---

# {{ $frontmatter.title }}

## 5.37

result as follow

we execute the blue first, then green, last red

<img width='600' src='https://raw.githubusercontent.com/shellRaining/img/main/2307/datapath1.png'>

## 5.39

result as follow

we execute the green first, then red

<img width='600' src='https://raw.githubusercontent.com/shellRaining/img/main/2307/datapath2.png'>

## 6.24

0110 000 001 000001

because the opcode is ldr, also we notice that r0 have changed after execute x3050, so destination register is r0, and the offset should between [-255, 256], so we choice r1 as source register, then offset is 1

## 7.32

| symbol | addr  |
| ------ | ----- |
| skip   | x8009 |
| A      | x800a |
| B      | x8011 |
| BANNER | x8012 |
| C      | x801F |

```asm
x8006 0010 001 000000011
x8007 0000 010 000000001
x8008 0011 000 000001000
```

because line 10 will fill B with 5, which is conflict with the effect of line 3

## 7.34

```asm
not r2, r0
add r2, r2, 1
brz DONE
add r0, r0, 1
```
