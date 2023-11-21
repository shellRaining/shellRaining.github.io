---
title: lab4
tag:
  - patt
description: report of lab4
---

# {{ $frontmatter.title }}

## algorithm

<img width='400' src='https://raw.githubusercontent.com/shellRaining/img/main/2307/lab4flowchart.png'>

## code

```asm
.orig x2f00
    ; save regs for user program
	st r0, trap_save_r0
	st r1, trap_save_r1
	st r2, trap_save_r2
	st r3, trap_save_r3
	st r4, trap_save_r4

	; read from kbdr
	ldi r0, n_kbdr

    ; ...

	; add r0 to bird_info_pos
	ld r3, bird_info_pos
	ldr r1, r3, 0
	add r1, r1, r0


kb_int_end
	ld r0, trap_save_r0
	ld r1, trap_save_r1
	ld r2, trap_save_r2
	ld r3, trap_save_r3
	ld r4, trap_save_r4

	rti

n_kbdr .fill xfe02
dsr .fill xfe04
ddr .fill xfe06
trap_save_r0 .blkw 1
trap_save_r1 .blkw 1
trap_save_r2 .blkw 1
trap_save_r3 .blkw 1
trap_save_r4 .blkw 1

bird_info_pos .fill x3060

zero .fill x30
nine .fill x39
a .fill x61
z .fill x7a
.end
```

the user program not show in this code, because it's not important for trap lab

## Q&A

### Q1. what will happened if you encounter a new keyboard interrupt when you are processing a previous keyboard interrupt?

A. the new interrupt will be delayed until the previous interrupt is processed

### Q2. introduce the process of keyboard interrupt

1. enable the keyboard interrupt bit, and set the the highest bit to 1, which means CPU need handle the interrupt
2. when user press the keyboard, the keyboard will send a signal to the computer
3. CPU knows it should handle interrupt first, get the interrupt vector from the interrupt vector table, and set pc to the interrupt handler
4. in interrupt handler, CPU will save current status, and do somethings... in this lab it update the bird position
5. CPU will restore the status, then use rti to return to the user program
