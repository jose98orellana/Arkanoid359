@ Code Section
.section .text

// assembly operator alignment to 4 bytes
.align 4

.global check_ball_fall_out

// check_ball_fall_out function
//  used to check if the ball is fall out from the screen
//  if the ball is fell out, then reduct the live by 1 and reset the ball
//  and paddle back to initial place
check_ball_fall_out:
	push {lr}
	
	// check the y coordinate of the ball
	ldr	r0, =ball_y
	ldr r0, [r0]
	mov r1, #984
	cmp r0, r1
	blt	check_ball_fall_out_end
	
	// reduct the live by 1
	ldr r0, =liveNum
	ldrsb r1, [r0]
	sub	r1, r1, #1
	strb r1, [r0]
	
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
	mov 		r1, #449
	str 		r1, [r0]
	
	//Reset ball's y coordinate
	ldr 		r0, =ball_y
	mov 		r1, #949
	str 		r1, [r0]
	
	//Reset paddle's position
	ldr 		r0, =paddle_x
	mov 		r1, #414
	str 		r1, [r0]
	
	check_ball_fall_out_end:
	pop	{pc}
