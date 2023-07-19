---
title: lab1
tag:
  - patt
description: report of lab1
---

# {{ $frontmatter.title }}

the bin file code as listed

```bin
; start from 0x3000
0011000000000000 ; start from x3000
0010000011111111 ; load num string from x3100
0010001011111111 ; load mask num
0010100011111111 ; load cnt num
0101010010100000 ; clear r2

; start loop
0101011000000001 ; r3 = r0 & r1
1001101001111111 ; if r3 - r1 == 0, then r2 = 1, while r5 = -r1
0001101101100001
0001011011000101
0000010000000100 ; if r3 == 0 jump to HAS
0001001001000001 ; r1 = r1 << 1
0001100100111111 ; r4 = r4 - 1
0000010000000010 ; if r4 != 0 then jump to NOTHAS
0000111111110111 ; jump to loop

; HAS
0001010010100001 ; set r2 to 1

; NOTHAS
1111000000100101 ; halt
```

Corresponds to the assembly code below.

```asm
; if the value stored in VALUE contained substring 111, then put r2 to 1, otherwise put r2 to 0

.ORIG x3000

; r0 = VALUE const
ld r0, VALUE

; r1 = MASK const
ld r1, MASK

; r4 = 14 as counter
ld r4, CNT

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
