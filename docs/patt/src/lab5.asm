.orig x3000
ld r6, stack
longestIncreasingPath
	; init i and j
	ldi r1, m
	ldi r2, n
	st r1, i
	st r2, j

outerLoop
	ld r1, i
	add r1, r1, #-1
	st r1, i
	brn done

innerLoop
	ld r2, j
	add r2, r2, #-1
	st r2, j
	brn endInnerLoop

	and r3, r3, #0
	add r3, r3, #1

	; r1 = i, r2 = j, r3 = step(1) and let r0 = lip(1, i, j) in the end
	add r6, r6, #-1 ; push j
	str r2, r6, #0
	add r6, r6, #-1 ; push i
	ld r1, i
	str r1, r6, #0
	add r6, r6, #-1 ; push step
	str r3, r6, #0
	jsr lip
	ldr r0, r6, 0 ; get return value
	add r6, r6, #4 ; pop parameters and return value

	; res = t > res ? t : res
	ld r1, res
	add r2, r0, #0
	add r3, r1, #0
	not r3, r3
	add r3, r3, #1
	add r3, r2, r3
	brnz notUpdateRes
	st r0, res
notUpdateRes
	brnzp innerLoop

endInnerLoop
	ldi r2, n
	st r2, j
	brnzp outerLoop
	
done
	ld r0, res
	ld r1, zero
	add r0, r0, r1
	trap x21
	halt

lip
	add r6, r6, -1 ; push return value as 0
	and r0, r0, 0
	str r0, r6, 0
	add r6, r6, -1 ; push return value
	str r7, r6, 0 ; push return address
	add r6, r6, -1 ; push old fp
	str r5, r6, 0
	add r5, r6, -1 ; set new fp
	add r6, r6, -2 ; push temp var used in this function (contained two var)

	and r0, r0, #0 ; int tmp = 0
	str r0, r5, 0

	ldr r0, r5, 5 ; get x
	and r2, r2, 0
	ldi r3, n
mult1
	add r0, r0, 0
	brz finishMult1
	add r2, r2, r3
	add r0, r0, -1
	brnzp mult1

finishMult1
	ldr r3, r5, 6 ; get y
	add r2, r2, r3
	str r2, r5, -1 ; int index = n * x + y

	; if (x-1 >= 0 && map[x-1][y] < map[x][y])
	ldr r0, r5, 5 ; get x
	add r1, r0, #-1
	brn skip1

	ldr r0, r5, -1 ; r0 = index
	ldi r1, n ; r1 = n
	not r1, r1
	add r1, r1, 1
	add r1, r0, r1 ; r0 = index - n
	ld r2, mapAddr
	add r3, r2, r1 ; r3 = &matrix[x-1][y]
	ldr r3, r3, 0 ; r3 = matrix[x-1][y]
	add r4, r2, r0 ; r4 = &matrix[x][y]
	ldr r4, r4, 0 ; r4 = matrix[x][y]
	not r4, r4
	add r4, r4, 1
	add r3, r3, r4 ; r3 = matrix[x-1][y] - matrix[x][y]
	brzp skip1

	ldr r1, r5, 4 ; r1 = step
	add r1, r1, 1
	ldr r2, r5, 5 ; r2 = x
	add r2, r2, #-1
	ldr r3, r5, 6 ; r3 = y

	add r6, r6, #-1 ; push j
	str r3, r6, #0
	add r6, r6, #-1 ; push i
	str r2, r6, #0
	add r6, r6, #-1 ; push step
	str r1, r6, #0
	jsr lip
	ldr r0, r6, 0 ; get return value
	add r6, r6, #4 ; pop parameters

	ldr r1, r5, 0 ; r1 = max
	not r2, r1
	add r2, r2, 1
	add r2, r0, r2 ; r2 = ret - max
	brnz skip1
	str r0, r5, 0 ; max = ret

skip1
	; if (x+1 < m && map[x+1][y] < map[x][y])
	ldr r0, r5, 5 ; get x
	add r0, r0, #1
	ldi r1, m
	not r1, r1
	add r1, r1, 1
	add r0, r0, r1
	brzp skip2 ; x+1 < m

	ldr r0, r5, -1 ; r0 = index
	ldi r1, n ; r1 = n
	add r1, r1, r0 ; r1 = index + n
	ld r2, mapAddr
	add r3, r2, r1 ; r3 = &matrix[x+1][y]
	ldr r3, r3, 0 ; r3 = matrix[x+1][y]
	add r4, r2, r0 ; r4 = &matrix[x][y]
	ldr r4, r4, 0 ; r4 = matrix[x][y]
	not r4, r4
	add r4, r4, 1
	add r3, r3, r4 ; r3 = matrix[x+1][y] - matrix[x][y]
	brzp skip2

	ldr r1, r5, 4 ; r1 = step
	add r1, r1, 1
	ldr r2, r5, 5 ; r2 = x
	add r2, r2, #1
	ldr r3, r5, 6 ; r3 = y

	add r6, r6, #-1 ; push j
	str r3, r6, #0
	add r6, r6, #-1 ; push i
	str r2, r6, #0
	add r6, r6, #-1 ; push step
	str r1, r6, #0
	jsr lip
	ldr r0, r6, 0 ; get return value
	add r6, r6, #4 ; pop parameters

	ldr r1, r5, 0 ; r1 = max
	not r2, r1
	add r2, r2, 1
	add r2, r0, r2 ; r2 = ret - max
	brnz skip2
	str r0, r5, 0 ; max = ret

skip2
	; if (y-1 >= 0 && map[x][y-1] < map[x][y])
	ldr r0, r5, 6 ; get y
	add r0, r0, #-1
	brn skip3

	ldr r0, r5, -1 ; r0 = index
	add r1, r0, #-1 ; r1 = index - 1
	ld r2, mapAddr
	add r3, r2, r1 ; r3 = &matrix[x][y-1]
	ldr r3, r3, 0 ; r3 = matrix[x][y-1]
	add r4, r2, r0 ; r4 = &matrix[x][y]
	ldr r4, r4, 0 ; r4 = matrix[x][y]
	not r4, r4
	add r4, r4, 1
	add r3, r3, r4 ; r3 = matrix[x][y-1] - matrix[x][y]
	brzp skip3

	ldr r1, r5, 4 ; r1 = step
	add r1, r1, 1
	ldr r2, r5, 5 ; r2 = x
	ldr r3, r5, 6 ; r3 = y
	add r3, r3, #-1

	add r6, r6, #-1 ; push j
	str r3, r6, #0
	add r6, r6, #-1 ; push i
	str r2, r6, #0
	add r6, r6, #-1 ; push step
	str r1, r6, #0
	jsr lip
	ldr r0, r6, 0 ; get return value
	add r6, r6, #4 ; pop parameters

	ldr r1, r5, 0 ; r1 = max
	not r2, r1
	add r2, r2, 1
	add r2, r0, r2 ; r2 = ret - max
	brnz skip3
	str r0, r5, 0 ; max = ret

skip3
	; if (y+1 < n && map[x][y+1] < map[x][y])
	ldr r0, r5, 6 ; get y
	add r0, r0, #1
	ldi r1, n
	not r1, r1
	add r1, r1, 1
	add r0, r0, r1
	brzp skip4 ; y+1 < n

	ldr r0, r5, -1 ; r0 = index
	add r1, r0, #1 ; r1 = index + 1
	ld r2, mapAddr
	add r3, r2, r1 ; r3 = &matrix[x][y+1]
	ldr r3, r3, 0 ; r3 = matrix[x][y+1]
	add r4, r2, r0 ; r4 = &matrix[x][y]
	ldr r4, r4, 0 ; r4 = matrix[x][y]
	not r4, r4
	add r4, r4, 1
	add r3, r3, r4 ; r3 = matrix[x][y+1] - matrix[x][y]
	brzp skip4

	ldr r1, r5, 4 ; r1 = step
	add r1, r1, 1
	ldr r2, r5, 5 ; r2 = x
	ldr r3, r5, 6 ; r3 = y
	add r3, r3, #1

	add r6, r6, #-1 ; push j
	str r3, r6, #0
	add r6, r6, #-1 ; push i
	str r2, r6, #0
	add r6, r6, #-1 ; push step
	str r1, r6, #0
	jsr lip
	ldr r0, r6, 0 ; get return value
	add r6, r6, #4 ; pop parameters

	ldr r1, r5, 0 ; r1 = max
	not r2, r1
	add r2, r2, 1
	add r2, r0, r2 ; r2 = ret - max
	brnz skip4
	str r0, r5, 0 ; max = ret

skip4
	ldr r0, r5, 0 ; get tmp
	add r0, r0, 1
	str r0, r5, 3 ; return value = tmp + 1

	add r6, r5, 1 ; pop temp var
	ldr r5, r6, 0 ; pop old fp
	add r6, r6, 1
	ldr r7, r6, 0 ; pop return address
	add r6, r6, 1
	ret

i .fill 0
j .fill 0
res .fill #0
zero .fill x30
stack .fill x4000
m .fill x4000
n .fill x4001
mapAddr .fill x4002
.end

.orig x4000
.fill 3
.fill 3
.fill 9
.fill 9
.fill 4
.fill 6
.fill 6
.fill 8
.fill 2
.fill 2
.fill 1
; .fill #3 ;n
; .fill #4 ;m
; .fill #89
; .fill #88
; .fill #86
; .fill #83
; .fill #79
; .fill #73
; .fill #90
; .fill #80
; .fill #60
; .fill #69
; .fill #73
; .fill #77
.end
