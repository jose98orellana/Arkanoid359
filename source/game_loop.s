.section	.text

.globl	run_game_loop
run_game_loop:
	push	{lr}

state0:
	bl	reset_game_vars
	bl	clearScreen

//Draw start screen with arrow next to start Image
state1:
	bl	clearScreen
	bl	draw_menu
	
	mov	r0, #860		//x-cordinate
	mov	r1, #500		//y-cordinate
	ldr	r2, =0xFFFF2AE1	
	bl	drawArrow

state1Loop:
	// Down D-Pad Pressed?
	bl	check_down_button
	cmp	r0, #1
	beq	state2

	// A pressed?
	bl	check_a_button
	cmp	r0, #1
	beq	state3
	
	b	state1Loop	

state2:
	bl	clearScreen
	bl	draw_menu

	mov	r0, #860		//x-cordinate
	mov	r1, #700		//y-cordinate
	ldr	r2, =0xFFFF2AE1
	bl	drawArrow
	

state2Loop:
	// Up D-pad Pressed?
	bl	check_up_button
	cmp	r0, #1
	beq	state1

	// A pressed?
	bl	check_a_button
	cmp	r0, #1
	beq	state7
	
	b	state2Loop

state3:
	bl	clearScreen

	bl	DrawBackground
	bl	DrawBoundaries
	bl	startLives
	bl	startScore
	
	bl 	printLiveNum
	bl 	printScoreNum
	
	bl	DrawGrid
	
	ldr	r1, =paddle_x
	ldr	r0, [r1]
	bl	DrawPaddle
	
	ldr	r2, =ball_x
	ldr	r0, [r2]
	ldr	r2, =ball_y
	ldr	r1, [r2]
	bl	DrawBall

	bl	delay
	b	state3Loop

state3Loop:
	// MAIN GAME LOOP	
	
	// Start Pressed?, open pause screen
	bl	check_start_button
	cmp	r0, #1
	beq	state5

	ldr	r0, =flag_win
	ldrsb	r1, [r0]
	cmp	r1, #1
	beq	state8

	ldr	r0, =flag_lose
	ldrsb	r1, [r0]
	cmp	r1, #1
	beq	state9
	
	bl	action_release_ball
	
	bl	move_paddle_with_ball
	bl 	move_paddle

	bl	collide_check
	
	bl  	check_ball_fall_out
	
	bl  	update_win_flag
	bl	update_lose_flag

	b	state3

state5:
	// Draw pauseMenu (arrow on "Continue")
	bl	clearScreen
	bl 	DrawPauseBack
	bl	printPause	
	bl	printCont
	bl	printQuit

	mov	r0, #860
	mov	r1, #500
	ldr	r2, =0xFFFF2AE1
	bl	drawArrow

state5Loop:
	//Down Pressed?
	bl	check_down_button
	cmp	r1, #1
	beq	state6

	//A pressed?
	bl	check_a_button
	cmp	r0, #1
	beq	state3

	//Start pressed?
	bl	check_start_button
	cmp	r0, #1
	beq 	afterPause

	b	state5Loop

state6:
	// Draw pauseMenu (arrow on "Quit Game")
	bl	clearScreenP
	bl 	DrawPauseBack
	bl	printPause	
	bl	printCont
	bl	printQuit

	mov	r0, #860
	mov	r1, #700
	ldr	r2, =0xFFFF2AE1
	bl	drawArrow

state6Loop:
	// Up D-pad pressed?
	bl	check_up_button
	cmp	r0, #1
	beq	state5

	// A pressed?
	bl	check_a_button
	cmp	r0, #1
	beq	state7

	// start pressed?
	bl	check_start_button
	cmp	r0, #1
	beq	afterPause

	b	state6Loop

// REDRAW THE GAME BOARD AFTER A PAUSE	
afterPause:
	// Remake the game board
	bl	clearScreen
	b	state3

//-------------------------------------------------------------------------------------------------------------------------
// Game Over Sub
state7:	
	// Game Over
	bl	clearScreen
	bl 	drawGameOver
	bl 	delay

	b 	state10
	
// Win Game Sub
state8:
	// Win Game!!!
	bl	clearScreen
	bl	drawWinImage	
	bl 	delay

	b 	state10

// Lose Game Sub
state9:
	// Lose Game
	bl	clearScreen
	bl	drawLoseImage
	bl	delay
	
	b	state10

// Wait for input to restart game
state10:
	// Wait for input to go back to main menu
state10Loop:

	bl	check_start_button
	cmp	r0, #1
	beq	end10Loop
	b	state10Loop
	
end10Loop:	
	bl	delay
	b	state0

delay:
	push	{r4, lr}
	mov	r4, #0
delayLoop:	
	cmp	r4, #1600		// r0 < 1600?
	bge	exitLoop
	mov	r0, #10
	bl	delayMicroseconds
	add	r4, #1			//r0++
	b	delayLoop		//branch back to delay
exitLoop:
	pop	{r4, pc}
