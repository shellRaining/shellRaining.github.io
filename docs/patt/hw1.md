---
title: Homework 1
tag:
  - patt
description: introduction to computer systems Homework 1
---

# {{ $frontmatter.title }}

## 1.2

> Can a higher-level programming language instruct a computer to compute more than a lower-level programming language?

no, it can't. becasue the higher-level programming language must be compiled to the lower-level programming language, so the generated instructions are a subset of low-level instructions.

## 1.4

> Name one characteristic of natural languages that prevents them from being used as programming languages

ambiguity, people can infer the meaning of a word by its context, however, computer can't.

## 1.10

> Name three characteristics of algorithms. Brieflfly explain each of these three characteristics

- definiteness: each step can be described precisely
- effective computability: each step can be executed by a computer
- finiteness: the algorithm must terminate after a finite number of steps

## 1.16

> Name at least three things specifified by an ISA

- the number and representation of opcode and operands
- how to find the operands in memory (addressing mode)
- the number of unique locations that comprise the computer’s memory and the number of individual 0s and 1s that are contained in each location

## 1.18

> How many ISAs are normally implemented by a single microarchitecture? Conversely, how many microarchitectures could exist for a single ISA?

one microarchitecture can implemente many ISAs, but one ISA can only be implemented by one microarchitecture.

## 2.4

> Given n bits, how many unsigned integers can be represented with the n bits? What is the range of these integers?

2^n, and from [0, 2^n - 1]

## 2.8

> a. What is the largest positive number one can represent in an eight-bit 2’s complement code? Write your result in binary and decimal.
> b. What is the greatest magnitude negative number one can represent in an eight-bit 2’s complement code? Write your result in binary and decimal.
> c. What is the largest positive number one can represent in n-bit 2’s complement code?
> d. What is the greatest magnitude negative number one can represent in n-bit 2’s complement code?

a. 01111111, 127
b. 10000000, -128
c. 2^(n-1) - 1
d. -2^(n-1)

## 2.17

> Add the following 2’s complement binary numbers. Also express the answer in decimal.
> a. 01 + 1011
> b. 11 + 01010101
> c. 0101 + 110
> d. 01 + 10

a. 1100 -4
b. 01011000 88
c. 1011 -5
d. 11 -1

## 2.20

> The following binary numbers are four-bit 2’s complement binary numbers. Which of the following operations generate overflow? Justify your answer by translating the operands and results into decimal.
> a. 1100 + 0011 d. 1000 − 0001
> b. 1100 + 0100 e. 0111 + 1001
> c. 0111 + 0001

a. 1111 -1 no overflow
b. 0000 0 no overflow
c. 1000 -8 overflow
d. 0111 7 overflow
e. 0000 0 no overflow

## 2.34

> Compute the following:
> a. NOT(1011) OR NOT(1100)
> b. NOT(1000 AND (1100 OR 0101))
> c. NOT(NOT(1101))
> d. (0110 OR 0000) AND 1111

a. 0111
b. 0111
c. 1101
d. 0110
