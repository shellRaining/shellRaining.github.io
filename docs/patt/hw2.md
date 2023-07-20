---
title: Homework 2
tag:
  - diary
description: introduction to computer systems Homework 2
---

# {{ $frontmatter.title }}

## 2.40

> Write the decimal equivalents for these IEEE floating point
> numbers.
>
> a. 0 10000000 00000000000000000000000
> b. 1 10000011 00010000000000000000000
> c. 0 11111111 00000000000000000000000
> d. 1 10000000 10010000000000000000000

a. 2.0
b. -1.0625
c. NaN
d. -3.125

## 2.48

> Convert the following decimal numbers to hexadecimal representations
> of 2’s complement numbers.
>
> a. 256
> b. 111
> c. 123,456,789
> d. −44

a. 0x4380 0000
b. 0x42DE 0000
c. 0x4CEB 79A3 (rounding to 1)
d. 0xC230 0000

## 3.6

> For the transistor-level circuit in Figure 3.38, fill in the truth table. What
> is Z in terms of A and B?

| A   | B   | C   | D   | Z   |
| --- | --- | --- | --- | --- |
| T   | T   | F   | F   | T   |
| T   | F   | F   | T   | F   |
| F   | T   | T   | F   | F   |
| F   | F   | T   | T   | F   |

## 3.20

> How many output lines will a 16-input multiplexer have? How many
> select lines will this multiplexer have?

1 output line, 4 select lines

## 3.30

> a. Figure 3.42 shows a logic circuit that appears in many of today’s
> processors. Each of the boxes is a full-adder circuit. What does the
> value on the wire X do? That is, what is the difference in the output
> of this circuit if X = 0 vs. if X = 1?
> b. Construct a logic diagram that implements an adder/subtractor. That
> is, the logic circuit will compute A + B or A − B depending on
> the value of X. Hint: Use the logic diagram of Figure 3.42 as a
> building block.

a. X is used to control whether to use b value, if X = 0, then use Bn, if X = 1, then use Cn
b. we treat Figure 3.42 as block S, then we get the following diagram:

    <img width='200' src='https://raw.githubusercontent.com/shellRaining/img/main/2307/suber.jpg'>

## 3.36

> A comparator circuit has two 1-bit inputs A and B and three 1-bit outputs
> G (greater), E (Equal), and L (less than). Refer to Figures 3.43 and 3.44
> for this problem.
>
> a. Draw the truth table for a one-bit comparator.
> b. Implement G, E, and L using AND, OR, and NOT gates.
> c. Using the one-bit comparator as a basic building block, construct a
> four-bit equality checker such that output EQUAL is 1 if A30 = B30,
> 0 otherwise.

a.

| A   | B   | G   | E   | L   |
| --- | --- | --- | --- | --- |
| 0   | 0   | 0   | 1   | 0   |
| 0   | 1   | 0   | 0   | 1   |
| 1   | 0   | 1   | 0   | 0   |
| 1   | 1   | 0   | 1   | 0   |

b. img as follow

    <img width='400' src='https://raw.githubusercontent.com/shellRaining/img/main/2307/comp.jpg'>

c. img as follow

    <img width='400' src='https://raw.githubusercontent.com/shellRaining/img/main/2307/comp2.jpg'>

## 3.40

> For the memory shown in Figure 3.45:
> a. What is the address space?
> b. What is the addressability?
> c. What is the data at address 2?

a. 3
b. 4
c. 0001

## 3.50

> Prove that the NAND gate, by itself, is logically complete (see
> Section 3.3.5) by constructing a logic circuit that performs the AND
> function, a logic circuit that performs the NOT function, and a logic
> circuit that performs the OR function. Use only NAND gates in these
> three logic circuits.

solution as follow

<img width='200' src='https://raw.githubusercontent.com/shellRaining/img/main/2307/nand.jpg'>
