## code and why to do

```asm
.orig x3000

; get the pointer of s1, s2
; let r1 = s1
; let r2 = s2
ldi r1, s1
ldi r2, s2

; get the total num of every char in s1 and s2
; malloc arr a1[32] a2[32]

; while (s1) set char for a1
loop1
    ; we use r3 to represent index, use r4 as temp
    ldr r3, r1, 0
    brz loop2
    ; s1++
    add r1, r1, 1
    ; if r3 == " ", then goto loop1, equal with continue
    ld r4, space
    add r4, r3, r4
    brz loop1

    ; make a to A, A to A
    ; r3 = r3 - 65
    ld r4, chead
    add r3, r3, r4
    ; r4 = r3 - 26
    ld r4, cnum
    add r4, r3, r4
    ; if r4 < 0 then not set r3, else r3 = r4 - 32, which means a to A
    brn set1
    ld r4, AaInterval
    add r3, r3, r4
set1
    ; r5 = &m[index]
    lea r4, a1
    add r4, r4, r3
    ; r5 = *r4, which means r5 = m[index]
    ldr r5, r4, 0
    ; r5++
    add r5, r5, 1
    ; *r4 = r5
    str r5, r4, 0
    brnzp loop1

; while (s2) set char for a2
loop2
    ; we use r3 to represent index, use r4 as temp
    ldr r3, r2, 0
    brz compare
    ; s2++
    add r2, r2, 1
    ; if r3 == " ", then goto loop2, equal with continue
    ld r4, space
    add r4, r3, r4
    brz loop2

    ; make a to A, A to A
    ; r3 = r3 - 65
    ld r4, chead
    add r3, r3, r4
    ; r4 = r3 - 26
    ld r4, cnum
    add r4, r3, r4
    ; if r4 < 0 then not set r3, else r3 = r4 - 32, which means a to A
    brn set2
    ld r4, AaInterval
    add r3, r3, r4
set2
    ; r5 = &m[index]
    lea r4, a2
    add r4, r4, r3
    ; r5 = *r4, which means r5 = m[index]
    ldr r5, r4, 0
    ; r5++
    add r5, r5, 1
    ; *r4 = r5
    str r5, r4, 0
    brnzp loop2

; compare the char num of s1, s2, if all equal, print true
compare
    ; r1 = &a1[0]; r2 = &a2[0]
    lea r1, a1
    lea r2, a2
    ; loop for 26 times, if one item not equal, goto notEqual, else goto Equal
    ; details as follow
    ; while(r3 >= 0) do
    ;   if a1[r3] != a2[r3] goto notEqual
    ;   r3--
    ; at first r3 = 25
    and r3, r3, 0
    add r3, r3, #15
    add r3, r3, #10
loop3
    ; r4 = a1[r3]; r5 = a2[r3]
    lea r4, a1
    lea r5, a2
    add r4, r3, r4
    add r5, r3, r5
    ldr r4, r4, 0
    ldr r5, r5, 0
    ; calc r4 - r5
    not r5, r5
    add r5, r5, 1
    add r4, r4, r5
    ; if r4 - r5 == 0 goto notEqual
    brnp notEqual
    ; r3--
    add r3, r3, #-1
    brzp loop3

Equal
    ld r0, yes
    trap x21
    halt

notEqual
    ld r0, no
    trap x21
    halt


s1 .fill x4000
s2 .fill x4001
a1 .blkw #32 ; x20
a2 .blkw #32
chead .fill #-65
cnum .fill #-26
AaInterval .fill #-32
space .fill #-32
yes .stringz "y"
no .stringz "n"
.end

; place to store string addr
.orig x4000
.FILL str1
.FILL str2
str1 .STRINGZ "dormitory"
str2 .STRINGZ "dirty room"
.end
```
