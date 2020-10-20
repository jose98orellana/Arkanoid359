@ Code Section
.section .text

// assembly operator alignment to 4 bytes
.align 4

.global update_win_flag
.global update_lose_flag

// update_win_flag
//  used to update the win flag by the condition:
//  if the live of all bricks are 0, then set the win flag to true
update_win_flag:
	push	{lr}
	
	ldr		r0, =brick_lives
	mov		r1, #0
	mov		r2, #30
	
	check_brick_lives_start:
	cmp		r1, r2
	bge		update_win_flag_set_win
	
	ldrsb		r3, [r0, r1]
	cmp		r3, r1
	bgt		update_win_flag_end
	
	add		r1, r1, #1
	b		check_brick_lives_start
	
	update_win_flag_set_win:
	ldr		r0, =flag_win
	mov		r1, #1
	strb		r1, [r0]
	
	update_win_flag_end:
	pop		{pc}
	
// update_lose_flag
//  used to update the lose flag by the condition:
//  if the live of player reaches 0, then set the lose flag to true
update_lose_flag:
	push	{lr}
	
	ldr		r0, =liveNum
	ldrsb		r1, [r0]
	cmp		r1, #0
	bgt		update_lose_flag_end
	
	ldr		r0, =flag_lose
	mov		r1, #1
	strb		r1, [r0]
	
	update_lose_flag_end:
	pop		{pc}
