; this is a lc3 asm file, to implement a simple deque

.orig x3000

; read char from keyboard and echo it
lea r3, cmdstring
readloop
	; read char if \n break
	trap x20
	trap x21
	add r1, r0, 0
	add r1, r1, #-10
	brz endInput
	str r0, r3, 0
	add r3, r3, 1
	brnzp readloop

endInput
; r0 = s, r3 = res
lea r0, cmdstring
lea r3, res
; r1 = sp, r2 = qp = sp + 1
ld r1, deqPos
ld r2, deqPos
add r2, r2, #1

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

popl
	; if r1 = r2 - 1
	not r5, r1
	add r5, r2, r5
	brp popl1
	; *r3 = '-'
	ld r4, downChar
	not r4, r4
	add r4, r4, #1
	str r4, r3, 0
	; r3++
	add r3, r3, #1
	brnzp loop
popl1
	; else
	; r1++
	add r1, r1, #1
	; *r3 = *r1
	ldr r4, r1, 0
	str r4, r3, 0
	; r3++
	add r3, r3, #1
	brnzp loop

popr
	; if r1 > r2
	not r5, r1
	add r5, r2, r5
	brp popr1
	; *r3 = '-'
	ld r4, downChar
	not r4, r4
	add r4, r4, #1
	str r4, r3, 0
	; r3++
	add r3, r3, #1
	brnzp loop
popr1
	; else
	; r2--
	add r2, r2, #-1
	; *r3 = *r2
	ldr r4, r2, 0
	str r4, r3, 0
	; r3++
	add r3, r3, #1
	brnzp loop

pushr
	; *r2 = *r0
	ldr r4, r0, 0
	str r4, r2, 0
	; r2++
	add r2, r2, #1
	; r0++
	add r0, r0, #1
	brnzp loop

pushl
	; *r1 = *r0
	ldr r4, r0, 0
	str r4, r1, 0
	; r1--
	add r1, r1, #-1
	; r0++
	add r0, r0, #1
	brnzp loop

; the task of main is to print string stored in res
end
	; print res
	lea r0, res
	trap x22
	halt


; end print r3 string

deqPos .fill x4100
plus .fill #-43
minus .fill #-45
left .fill #-91
right .fill #-93
downChar .fill #-95
cmdstring .blkw #100
res .blkw #100
.end

.orig x4000
.blkw x100
deque .blkw x100
.end
