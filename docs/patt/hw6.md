---
title: Homework 6
tag:
  - patt
description: introduction to computer systems Homework 6
---

# {{ $frontmatter.title }}

## 8.2

> What is an advantage to using the model in Figure 8.9 to implement a
> stack vs. the model in Figure 8.8?

1. we need not to set a bit to represent whether the stack is empty or full
2. the data need not to be moved when push or pop, which is more efficient
3. easy to implement

## 8.8

> The following operations are performed on a stack:
> PUSH A, PUSH B, POP, PUSH C, PUSH D, POP, PUSH E, POP, POP, PUSH F

> a. What does the stack contain after the PUSH F?
> b. At which point does the stack contain the most elements? Without
> removing the elements left on the stack from the previous operations, we perform:
> PUSH G, PUSH H, PUSH I, PUSH J, POP, PUSH K,
> POP, POP, POP, PUSH L, POP, POP, PUSH M
> c. What does the stack contain now?

a. A F
b. when we psh J and push K, the stack contain the most elements, they are AFGHIJ and AFGHIK
c. AFM

## 7.30

```asm
a. brnp SKIP
b. add r5, r5, 1
c. str r0, r6, 0
d. ld r1, SAVER
```
