@.text section
.section .text

// assembly operator alignment to 4 bytes
.align 4

.global reset_game_vars

reset_game_vars:
	push	{r4, lr}
	
	// Reset lives
	ldr 		r0, =liveNum
	mov 		r1, #0
	strb 		r1, [r0]

	// Reset score
	ldr 		r0, =scoreNum
	mov 		r1, #0
	strb		r1, [r0]
	strb 		r1, [r0, #1]
	strb 		r1, [r0, #2]
	
	//Reset game win flag
	ldr 		r0, =flag_win
	mov 		r1, #0
	strb 		r1, [r0] 
	
	//Reset game over flag
	ldr 		r0, =flag_lose
	mov 		r1, #0
	strb 		r1, [r0]
	
	//Reset game paused flag
	ldr 		r0, =flag_paused
	mov 		r1, #0
	strb 		r1, [r0]
	
	//Reset ball released flag
	ldr 		r0, =flag_ball_released
	mov 		r1, #0
	strb 		r1, [r0]
	
	//Reset ball's x-axis velocity
	ldr 		r0, =ball_x_vel
	mov 		r1, #0
	str 		r1, [r0]
	
	//Reset ball's y-axis velocity
	ldr 		r0, =ball_y_vel
	mov 		r1, #0
	str 		r1, [r0]
	
	//Reset ball's x coordinate
	ldr 		r0, =ball_x
	mov 		r1, #315
	str 		r1, [r0]
	
	//Reset ball's y coordinate
	ldr 		r0, =ball_y
	mov 		r1, #926
	str 		r1, [r0]
	
	//Reset paddle's position
	ldr 		r0, =paddle_x
	mov 		r1, #250
	str 		r1, [r0]
	
	//Reset brick_lives
	ldr			r0, =brick_lives
	ldr			r1, =brick_lives_default
	mov			r2, #0
	mov			r3, #30
	
	reset_brick_lives_start:
	cmp			r2, r3
	bge			reset_brick_lives_end			// if counter >= 30, jump out the loop
	ldrsb		r4, [r1, r2]					// load the default lives from array
	strb		r4, [r0, r2]					// store it back to the lives_array
	add			r2, r2, #1						// counter self-increment
	b			reset_brick_lives_start
	reset_brick_lives_end:
	
	pop	{r4, pc}
	
@ Data section
.section	.data
brick_lives_default:	.byte	3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
.align
