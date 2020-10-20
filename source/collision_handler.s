@ Code Section
.section .text

// assembly operator alignment to 4 bytes
.align 4

.global collide_check
collide_check:
	push	{r4, lr}
	
  collide_check_paddle:
	bl collide_paddle
	cmp r0, #0
	beq collide_check_walls
	bl collide_flip
	b collide_check_done
	
  collide_check_walls:
	bl collide_walls
	cmp r0, #0
	beq collide_check_bricks_all
	bl collide_flip
	
	mov r2, r1					// copy r1 to r2
	mov r3, #10					
	sub r2, r2, r3				// r2 = offset
	ldr r3, =brick_lives
	ldrsb r4, [r3, r2]
	sub r4, r4, #1				// live = live - 1
	strb r4, [r3, r2]
	
	b collide_check_done
	
  collide_check_bricks_all:
	bl collide_bricks_all
	cmp r0, #1
	bne collide_check_done
	
  collide_check_brick:
	bl collide_brick
	cmp r0, #0
	beq collide_check_done
	bl collide_flip
	
collide_check_done:
	pop	{r4, pc}

collide_flip:
	push	{r4-r7, lr}
	cmp r0, #1
	beq collide_flip_x
	cmp r0, #2
	beq collide_flip_x
	cmp r0, #3
	beq collide_flip_y
	cmp r0, #4
	beq collide_flip_y
	
	collide_flip_x:
	ldr r4, =ball_x_vel
	ldr r5, [r4]
	mov r6, #0
	sub r7, r6, r5
	str r7, [r4]
	b collide_flip_done
	
	collide_flip_y:
	ldr r4, =ball_y_vel
	ldr r5, [r4]
	mov r6, #0
	sub r7, r6, r5
	str r7, [r4]
	
collide_flip_done:
	pop	{r4-r7, pc}
	