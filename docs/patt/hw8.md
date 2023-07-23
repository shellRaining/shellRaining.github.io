---
title: Homework 8
tag:
  - patt
description: introduction to computer systems Homework 8
---

# {{ $frontmatter.title }}

## 9.16

> a. How many trap service routines can be implemented in the LC-3?
> Why?
> b. Why must a RTI instruction be used to return from a TRAP routine?
> Why won’t a BR (Unconditional Branch) instruction work instead?
> c. How many accesses to memory are made during the processing of a
> TRAP instruction? Assume the TRAP is already in the IR.

a. 256, because the trap vector is 8 bits, so the trap vector can be 0-255
b. because RTI not only load the next instruction after trap instruction, but also load the saved PSR in stack to check whether in supervisor mode, if the PSR[15] is represent User mode, RTI will load the saved User stack pointer to R6
c. two times, the first is to load the trap vector, such as `trap x21`, LC-3 should load the value in memory location x0021 to PC, the second is to load the instruction in pc

## 9.17

> Refer to Figure 9.14, the HALT service routine.

> a. What starts the clock after the machine is HALTed? Hint: How can
> the HALT service routine return after bit [15] of the Master Control
> Register is cleared?
> b. Which instruction actually halts the machine?
> c. What is the first instruction executed when the machine is started
> again?
> d. Where will the RTI of the HALT routine return to?

a. the clock is started by the hardware, if the top bit of MCR is 0, the LC-3 clock will be stopped, if the top bit of MCR is 1, the LC-3 clock will be started
b. the `trap x25` instruction
c. the instruction after set the top bit of MCR to 1
d. the instruction after `trap x25` instruction
