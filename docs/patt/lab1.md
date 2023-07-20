---
title: lab1
tag:
  - patt
description: report of lab1
---

# {{ $frontmatter.title }}

the bin file code as listed

```bin
     0011 0000 0000 0000 ; start from x3000
20ff 0010 0000 1111 1111 ; load value

5260 0101 0010 0110 0000 ; load MASK and cnt
1267 0001 0010 0110 0111
5920 0101 1001 0010 0000
192e 0001 1001 0010 1110

54a0 0101 0100 1010 0000
5601 0101 0110 0000 0001
9a7f 1001 1010 0111 1111
1b61 0001 1011 0110 0001
16c5 0001 0110 1100 0101
0404 0000 0100 0000 0100
1241 0001 0010 0100 0001
193f 0001 1001 0011 1111
0402 0000 0100 0000 0010
0ff7 0000 1111 1111 0111
14a1 0001 0100 1010 0001
f025 1111 0000 0010 0101
```

Corresponds to the assembly code below.

```asm
; if the value stored in VALUE contained substring 111, then put r2 to 1, otherwise put r2 to 0

.ORIG x3000

; r0 = VALUE const
ld r0, VALUE

; r1 = MASK const
and r1, r1, 0
add r1, r1, 7

; r4 = 14 as counter
and r4, r4, 0
add r4, r4, 14

; clear r2 as result
and r2, r2, #0

; judge loop
LOOP
	; r3 = r0 & r1
	and r3, r0, r1
	; if r3 - r1 == 0, then r2 = 1, while r5 = -r1
	not r5, r1
	add r5, r5, #1
	add r3, r3, r5
	brz HAS
	; r1 = r1 << 1
	add r1, r1, r1
	; r4 = r4 - 1
	add r4, r4, #-1
	; if r4 != 0, then jump to NOTHAS
	brz NOTHAS
	brnzp LOOP

HAS
	add r2, r2, #1

NOTHAS
	halt

.end

; place to store 16-bits string
.ORIG x3100
VALUE .fill b1010101010101110
MASK .fill b0000000000000111
CNT .fill #14
.END
```

1. we should store the value string in 0x3100, which contained VALUE, MASK and CNT.
2. load the value string from 0x3100 to r0, load the mask string from 0x3101 to r1, load the counter from 0x3102 to r4.
3. clear r2 as result.
4. we make value and mask do and operation, if the result equal with mask, which represent the value string contained 111, we goto HAS segment, else shift the mask to left one bit, for 14 times, because the len of string is 16, 14 = 16 - 3 + 1

add2
1010 1101 1101 0010
