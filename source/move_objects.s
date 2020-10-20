@ Code Section
.section .text

// assembly operator alignment to 4 bytes
.align 4

.global move_ball
.global move_paddle
.global move_paddle_with_ball
.global action_release_ball 

move_ball:
	push	{lr}
	
	ldr r1, =ball_x_vel
	ldr r3, [r1]
	ldr r1, =ball_x
	ldr r2, [r1]
	
	add r3, r3, r2
	str r3, [r1]
	
	ldr r1, =ball_y_vel
	ldr r3, [r1]
	ldr r1, =ball_y
	ldr r2, [r1]
	
	add r3, r3, r2
	str r3, [r1]
	
	pop	{pc}

move_paddle:
	push	{r4-r8, lr}
	
	ldr r0, =flag_ball_released
	ldrb r1, [r0]
	cmp r1, #0
	beq move_paddle_end
	
	bl check_left_button
	mov r1, #1
	cmp r0, r1
	beq move_paddle_left
	
	bl check_right_button
	mov r1, #1
	cmp r0, r1
	beq move_paddle_right
	
	b move_paddle_end
	
	move_paddle_left:
	bl check_a_button
	mov r4, #1					// r4 = speed = 1
	cmp r0, r4					// check if A button is pressed
	addeq r4, r4, #1			// r4 = speed + 1 = 2
	ldr r5, =paddle_x
	ldr r6, [r5]				// r6 = paddle_x
	sub r7, r6, r4
	cmp r7, #0					// if paddle_x - speed < 0
	movlt r7, #0				// then set paddle_x = 0
	str r7, [r5]
	b move_paddle_end
	
	move_paddle_right:
	bl check_a_button
	mov r4, #1					// r4 = speed = 1
	cmp r0, r4					// check if A button is pressed
	addeq r4, r4, #1			// r4 = speed + 1 = 2
	ldr r5, =paddle_x
	ldr r6, [r5]				// r6 = paddle_x
	add r7, r6, r5
	add r7, r7, #70
	mov r8, #599
	cmp r7, r8					// if paddle_x + speed > game_area_width
	movlt r7, #529				// then set paddle_x = 529 (max x)
	str r7, [r5]
	b move_paddle_end
	
	move_paddle_end:
	
	pop	{r4-r8, pc}

move_paddle_with_ball:
	push	{r4-r8, lr}
	
	ldr r0, =flag_ball_released
	ldrb r1, [r0]
	cmp r1, #1
	beq move_paddle_with_ball_end
	
	bl check_left_button
	mov r1, #1
	cmp r0, r1
	beq move_paddle_with_ball_left
	
	bl check_right_button
	mov r1, #1
	cmp r0, r1
	beq move_paddle_with_ball_right
	
	b move_paddle_with_ball_end
	
	move_paddle_with_ball_left:
	bl check_a_button
	mov r4, #1					// r4 = speed = 1
	cmp r0, r4					// check if A button is pressed
	addeq r4, r4, #1			// r4 = speed + 1 = 2
	ldr r5, =paddle_x
	ldr r6, [r5]				// r6 = paddle_x
	sub r7, r6, r4
	cmp r7, #0					// if paddle_x - speed < 0
	movlt r7, #0				// then set paddle_x = 0
	str r7, [r5]
	ldr r5, =ball_x
	ldr r6, [r5]				// r6 = ball_x
	add r6, r6, r4				// r6 = ball_x + speed
	str r6, [r5]
	b move_paddle_with_ball_end
	
	move_paddle_with_ball_right:
	bl check_a_button
	mov r4, #1					// r4 = speed = 1
	cmp r0, r4					// check if A button is pressed
	addeq r4, r4, #1			// r4 = speed + 1 = 2
	ldr r5, =paddle_x
	ldr r6, [r5]				// r6 = paddle_x
	add r7, r6, r5
	add r7, r7, #70
	mov r8, #599
	cmp r7, r8				// if paddle_x + speed > game_area_width
	movlt r7, #529				// then set paddle_x = 529 (max x)
	str r7, [r5]
	ldr r5, =ball_x
	ldr r6, [r5]				// r6 = ball_x
	add r6, r6, r4				// r6 = ball_x + speed
	str r6, [r5]
	b move_paddle_end
	
	move_paddle_with_ball_end:
	pop	{r4-r8, pc}
	
action_release_ball:
	push	{lr}
	
	ldr r0, =flag_ball_released
	ldrb r1, [r0]
	cmp r1, #1
	beq action_release_ball_end			// if the ball is released, then jump out
	
	bl check_b_button
	cmp r0, #0
	beq action_release_ball_end			// if B button is not pressed, then jump out
										// otherwise go to the release procedure

	ldr r0, =flag_ball_released
	mov r1, #1
	strb r1, [r0]						// set the released flag to true
	
	ldr r0, =ball_x_vel
	mov r1, #2
	str r1, [r0]						// set the ball x-velocity to 2
	
	ldr r0, =ball_y_vel
	mov r1, #-2
	str r1, [r0]						// set the ball y-velocity to -2
	
	action_release_ball_end:
	pop	{pc}
	