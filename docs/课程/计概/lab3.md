---
title: lab3
tag:
  - patt
description: report of lab3
---

# {{ $frontmatter.title }}

## algorithm

<img width='700' src='https://raw.githubusercontent.com/shellRaining/img/main/2307/lab3flowchart.png'>

It seems that sometimes the flowcharts drawn by Mermaid are not very beautiful...

## code

```asm
; while(*ro)
;	r0++
;	if *r0 == -
;		if r1 == r2, *r3++ = '-'
;		else r1++; *r3++ = *r1
;	elif *r0 == ]
;		if r1 == r2, *r3++ = '-'
;		else r2--; *r3++ = *r2
;	elif *r0 == [
;		r0++; *r2++ = *r0
;	elif *r0 == +
;		r0++; *r1-- = *r0
;	elif *r0 == 0
;		goto end
loop
	; let r4 = *r0
	ldr r4, r0, 0
	; r0++
	add r0, r0, #1
	; if r4 == -
	ld r5, minus
	add r5, r4, r5
	brz popl
	; if r4 == ]
	ld r5, right
	add r5, r4, r5
	brz popr
	; if r4 == [
	ld r5, left
	add r5, r4, r5
	brz pushr
	; if r4 == +
	ld r5, plus
	add r5, r4, r5
	brz pushl
	; if r4 == 0
	add r5, r4, 0
	brz end
```

## Q&A

> Q: does qp and sp contained the value in the index there are pointing to?

no, the index they pointed is where the next value will be push

> Q: how to judge if the stack is empty?

if qp == sp + 1, then the stack is empty
