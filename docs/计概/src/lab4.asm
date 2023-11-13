; boot program
.orig x0200

ld r6, os_sp

ld r0, user_psr
add r6, r6, #-1
str r0, r6, #0

ld r0, user_pc
add r6, r6, #-1
str r0, r6, #0

; enable keyboard interrupt
ld r0, enabled_kbsr
ld r1, kbsr
str r0, r1, 0

rti

os_sp .fill x3000
user_psr .fill x8002
user_pc .fill x3000
kbsr .fill xfe00
kbdr .fill xfe02
enabled_kbsr .fill xc000
.end

; keyboard interrupt vector table item
.orig x0180
kb_int .fill x2f00
.end

.orig x2f00
	st r0, trap_save_r0
	st r1, trap_save_r1
	st r2, trap_save_r2
	st r3, trap_save_r3
	st r4, trap_save_r4

	; read from kbdr
	ldi r0, n_kbdr

	; if (ro >= '0' && r0 <= '9') r1 = r0 - '0'
	; else if (r0 <= 'z' && r0 >= 'a') r1 = r0
	ld r1, zero
	not r1, r1
	add r1, r1, #1
	add r2, r0, r1
	brn kb_int_end

	ld r1, nine
	not r1, r1
	add r1, r1, #1
	add r2, r0, r1
	brp next_judge

	; r0 = r0 - '0'
	ld r1, zero
	not r1, r1
	add r1, r1, #1
	add r0, r0, r1

	; add r0 to bird_info_pos
	ld r3, bird_info_pos
	ldr r1, r3, 0
	add r1, r1, r0

	; r0 = max_len
	; r1 = bird_pos
	; r2 = 
	; r3 = bird_info_pos
	; r4 =
	ldr r0, r3, 2
	add r2, r1, #3
	not r2, r2
	add r2, r2, #1
	add r4, r0, r2
	brzp not_oper
	; let bird_pos = max_len - 3
	add r1, r0, #-3

not_oper

	str r1, r3, 0
	brnzp kb_int_end

next_judge
	ld r1, a
	not r1, r1
	add r1, r1, #1
	add r2, r0, r1
	brn kb_int_end

	ld r1, z
	not r1, r1
	add r1, r1, #1
	add r2, r0, r1
	brp kb_int_end

	; set bird_body to r0
	ld r3, bird_info_pos
	str r0, r3, 1

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

; user program
.orig x3000
; in this section, we will write a dead loop program, which will print "...xxx..." and so on every once in a while
; however, every 20 char printed, we will print \n to make it look like a new line

; main function
main
	; if (cur_char_col >= bird_pos && cur_char_col < bird_pos + 3) {
	;   printf("%c", bird_body);
	; } else {
	;   printf("%c", air);
	; }
	ld r0, cur_char_col
	ld r1, bird_pos

	not r3, r1
	add r3, r3, #1
	add r2, r0, r3
	brn execute_print_air

	add r3, r1, #3
	not r3, r3
	add r3, r3, #1
	add r2, r0, r3
	brzp execute_print_air

	brnzp execute_print_bird

execute_print_air
	jsr print_air
	brnzp finish_print

execute_print_bird
	jsr print_bird
	brnzp finish_print

finish_print
	; cur_char_col++;
	add r0, r0, #1
	st r0, cur_char_col

	; if (cur_char_col >= max_len) {
	;   cur_char_col = 0;
	;   bird_pos--;
	;   if (bird_pos < 0) {
	;     bird_pos = 0;
	;   } else if (bird_pos + 3 > max_len) {
	;     bird_pos = max_len - 3;
	;   }
	;   printf("\n");
	; }

handle_newline
	ld r0, cur_char_col
	ld r1, max_len

	; if cur_char_col < max_len then goto execute_delay
	not r3, r1
	add r3, r3, #1
	add r2, r0, r3
	; brn execute_delay
	brn main

	; cur_char_col = 0; bird_pos--;
	ld r2, bird_pos
	and r0, r0, #0
	add r2, r2, #-1
	st r0, cur_char_col
	st r2, bird_pos

	; if bird_pos < 0 then bird_pos = 0
	add r2, r2, 0
	brn execute_stay_bottom

	; else if bird_pos + 3 > max_len then bird_pos = max_len - 3
	add r3, r2, #3
	not r3, r3
	add r3, r3, #1
	ld r4, max_len
	add r4, r4, r3
	brn execute_stay_up
	
	jsr print_newline
	brnzp execute_delay

execute_stay_bottom
	jsr stay_bottom
	jsr print_newline
	brnzp execute_delay
	; brnzp main

execute_stay_up
	jsr stay_up
	jsr print_newline
	brnzp execute_delay
	; brnzp main
	
execute_delay
	jsr delay

	brnzp main

; store bird position to 0 function
stay_bottom
	st r0, stay_bottom_save
	and r0, r0, #0
	st r0, bird_pos
	ret
	stay_bottom_save .blkw 1
	
; store bird position to max_len - 3 function
stay_up
	st r0, stay_up_save
	ld r0, max_len
	add r0, r0, #-3
	st r0, bird_pos
	ret
	stay_up_save .blkw 1

; print bird_body function
print_bird
	st r0, print_bird_save
	ld r0, bird_body
	trap x21
	ld r0, print_bird_save
	ret
	print_bird_save .blkw 1

; print air function
print_air
	st r0, print_air_save
	ld r0, air
	trap x21
	ld r0, print_air_save
	ret
	print_air_save .blkw 1

; print newline
print_newline
	st r0, print_newline_save
	ld r0, newline
	trap x21
	ld r0, print_newline_save
	ret
	print_newline_save .blkw 1

newline .stringz "\n"

air .stringz "."
cur_char_col .fill #0

; delay function
delay
	st r1, save_r1
	ld r1, count
loop
	add r1, r1, #-1
	brnp loop
	ld r1, save_r1
	ret
count .fill x0FFF
save_r1 .blkw 1

.end

.orig x3060
bird_pos .fill #5
bird_body .fill x61 ; char 'a'
max_len .fill #20
.end
