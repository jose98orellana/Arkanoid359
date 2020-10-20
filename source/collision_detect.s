@ Code Section
.section .text

// assembly operator alignment to 4 bytes
.align 4

// Collision ID Table
//  ID below always returned in R0
//    0 - No collision
//   Ball's Side
//    1 - Left
//    2 - Right
//    3 - Top
//    4 - Bottom
//
//  ID below always returned in R1
//   Wall
//    1 - Left
//    2 - Right
//    3 - Top
//
//   Paddle
//    4 - Paddle
//
//   Bricks
//    10 ~ 19 - Top row of 10 walls from left to right
//    20 ~ 29 - Middle row of 10 walls from left to right
//    30 ~ 39 - Bottom row of 10 walls from left to right
//
// Be aware that the collide_bricks_all will only return 0 and 1 in R0
// Since it only be used for checking if the ball is in the brick area
// 0 - Not in Brick Area
// 1 - Inside the Brick Area

.global collide_walls
.global collide_paddle
.global collide_bricks_all
.global collide_brick

collide_walls:
	push	{r4-r8, lr}
	mov r0, #0				// return value
	ldr r1, =ball_x
	ldr r2, [r1]
	ldr r1, =ball_y
	ldr r3, [r1]
	ldr r1, =ball_x_vel
	ldr r4, [r1]
	ldr r1, =ball_y_vel
	ldr r5, [r1]
	
	collide_walls_left:
	mov r6, #0
	add r7, r2, r4
	cmp r7, r6
	movle r0, #1
	movle r1, #1
	ble collide_walls_done
	
	collide_walls_right:
	mov r6, #599
	mov r7, #14
	add r8, r2, r4
	add r7, r7, r8
	cmp r7, r6
	movge r0, #2
	movge r1, #2
	bge collide_walls_done
	
	collide_walls_top:
	mov r6, #0
	add r7, r3, r5
	cmp r7, r6
	movle r0, #3
	movle r1, #3
	ble collide_walls_done
  collide_walls_done:
	pop	{r4-r8, pc}
	

collide_paddle:
	push	{r4-r9, lr}
	mov r0, #0				// return value
	ldr r1, =ball_x
	ldr r2, [r1]
	ldr r1, =ball_y
	ldr r3, [r1]
	ldr r1, =ball_x_vel
	ldr r4, [r1]
	ldr r1, =ball_y_vel
	ldr r5, [r1]
	ldr r1, =paddle_x
	ldr r6, [r1]
	mov r7, #14
	
  collide_paddle_top:
	add r8, r3, r5			// r8 = ball_y + ball_y_vel
	add r8, r8, r7			// r8 = ball_y + ball_y_vel + ball_height
	mov r9, #964			// top surface of paddle
	cmp r8, r9
	blt collide_paddle_left
	add r8, r2, r4			// r8 = ball_x + ball_x_vel
	add r9, r6, #69			// r9 = paddle_x + width, right most pixel of paddle
	cmp r8, r9
	bge collide_paddle_left
	add r8, r8, r7
	cmp r8, r6
	ble collide_paddle_left
	mov r0, #4
	mov r1, #4
	b collide_paddle_done
	
  collide_paddle_left:
	add r8, r2, r4
	add r8, r7, r8
	cmp r8, r6
	blt collide_paddle_right
	add r8, r3, r5			// top-right pixel of ball's y coordinate
	mov r9, #978
	cmp r8, r9
	bge collide_paddle_right
	add r8, r7, r8			// bottom-right pixel of ball's y coordinate
	mov r9, #964			// top-left pixel of paddle's y coordinate
	cmp r8, r9
	ble collide_paddle_right
	mov r0, #2
	mov r1, #4
	b collide_paddle_done
	
  collide_paddle_right:
	add r8, r2, r4
	add r9, r6, #69
	cmp r8, r9
	bgt collide_paddle_done
	add r8, r3, r5
	mov r9, #978
	cmp r8, r9
	bge collide_paddle_done
	add r8, r7, r8
	mov r9, #964
	cmp r8, r9
	ble collide_paddle_done
	mov r0, #1
	mov r1, #4
  collide_paddle_done:
	pop	{r4-r9, pc}


collide_bricks_all:
	push	{r4-r6, lr}
	mov r0, #0				// return value
	
	ldr r1, =ball_y
	ldr r3, [r1]
	ldr r1, =ball_y_vel
	ldr r4, [r1]
	
	mov r5, #14
	
	add r6, r3, r4
	mov r7, #136
	cmp r6, r7
	movle r0, #1
	
	add r6, r6, r5
	mov r7, #49
	cmp r6, r7
	movge r0, #1

	pop	{r4-r6, pc}

collide_brick:
	push	{r4-r9, lr}
	
	ldr r1, =brick_lives

	ldr r0, =ball_y
	ldr r0, =ball_x_vel
	ldr r0, =ball_y_vel
	
	mov r2, #0				// outer loop counter i
	mov r3, #0				// inner loop counter j
	mov r4, #3				// outer loop upper limit
	mov r5, #10				// inner loop upper limit
	
	collide_brick_row_loop:
	cmp r2, r4
	bge collide_brick_row_loop_end
	
		collide_brick_col_loop:
		cmp r3, r5
		bge collide_brick_col_loop_end
		
			collide_brick_check_alive:
			mul r6, r2, r5
			add r6, r6, r3
			ldrsb r6, [r1, r6]
			mov r0, #0
			cmp r6, r0
			addle r3, r3, #1
			ble collide_brick_col_loop
			
			collide_brick_top:
			ldr r0, =ball_x
			ldr r6, [r0]
			ldr r0, =ball_x_vel
			ldr r7, [r0]
			add r8, r6, r7			// ball_x + ball_x_vel
			mov r0, #59
			mul r9, r3, r0			// brick.x = column * 59
			add r9, r9, r0			// brick.x + brick.width
			cmp r8, r9
			bgt collide_brick_left
			
			add r8, r8, #14			// ball_x + ball_x_vel + ball.width
			sub r9, r9, r0			// brick.x
			cmp r8, r9
			blt collide_brick_left
			
			ldr r0, =ball_y
			ldr r6, [r0]
			ldr r0, =ball_y_vel
			ldr r7, [r0]
			
			add r8, r6, r7
			add r8, r8, #14
			
			mov r0, #29
			mul r9, r4, r0
			add r9, r9, #49
			cmp r8, r9
			blt collide_brick_bottom
			mov r0, #4
			b collide_brick_row_loop_end
			
			collide_brick_bottom:
			sub r8, r8, #14
			add r9, r9, #29
			cmp r8, r9
			bgt collide_brick_left
			mov r0, #3
			b collide_brick_row_loop_end
			
			collide_brick_left:
			ldr r0, =ball_y
			ldr r6, [r0]
			ldr r0, =ball_y_vel
			ldr r7, [r0]
			add r8, r6, r7
			add r8, r8, #14
			
			mov r0, #29
			mul r9, r2, r0
			add r9, r9, #49
			
			cmp r8, r9
			blt collide_brick_check_end
			
			sub r8, r8, #14
			add r9, r9, #29
			cmp r8, r9
			bgt collide_brick_check_end
			
			ldr r0, =ball_x
			ldr r6, [r0]
			ldr r0, =ball_x_vel
			ldr r7, [r0]
			add r8, r6, r7
			add r8, #14
			
			mov r0, #49
			mul r9, r3, r0
			cmp r8, r9
			blt collide_brick_right
			mov r0, #2
			b collide_brick_row_loop_end
			
			collide_brick_right:
			sub r8, r8, #14
			add r9, r9, #59
			cmp r8, r9
			bgt collide_brick_check_end
			mov r0, #1
			b collide_brick_row_loop_end
			
			collide_brick_check_end:
			mov r0, #0				// return value
			
		add r3, r3, #1
		b collide_brick_col_loop
		
		collide_brick_col_loop_end:
		mov r3, #0
		
	add r2, r2, #1
	b collide_brick_row_loop
	
	collide_brick_row_loop_end:
	add r2, r2, #1
	mul r1, r2, r5
	add r1, r1, r3

  collide_brick_done:
	pop	{r4-r9, pc}

