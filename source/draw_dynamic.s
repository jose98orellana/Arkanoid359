.section	.text

.globl	DrawPaddle
DrawPaddle:
	push	{lr}

	ldr	r8, =#659
	add	r0, r8
	mov	r1, #1000

	add	r3, r0, #145
	add	r4, r1, #15

	loopPaddle:
		cmp	r0, r3
		bge	paddleNext
		
		ldr	r2, =0xFFA2A3A3
		push	{r0-r4}
		bl	DrawPixel
		pop	{r0-r4}

		add	r0, #1
		b 	loopPaddle

	paddleNext:
		sub	r0, #145
		add	r1, #1
		cmp	r1, r4
		popeq	{lr}
		moveq	pc, lr
		b	loopPaddle

@ DrawBall
@ x
@ y
.globl	DrawBall
DrawBall:
	push	{lr}
	
	ldr	r8, =#659
	add	r0, r8
	add	r1, #59

	add	r3, r0, #15
	add	r4, r1, #15

	loopBall:
		cmp	r0, r3
		bge	ballNext
		
		ldr	r2, =0xFFFCFEFF
		push	{r0-r4}
		bl	DrawPixel
		pop	{r0-r4}

		add	r0, #1
		b 	loopBall

	ballNext:
		sub	r0, #15
		add	r1, #1
		cmp	r1, r4
		popeq	{lr}
		moveq	pc, lr
		b	loopBall

@ DrawGrid
@ brick_lives

.globl	DrawGrid
DrawGrid:
	push	{lr}

	ldr	r5, =endBrickLives
	ldr	r6, =brick_lives

	mov	r0, #659	@ left-most brick x
	mov	r1, #209	@ left-most brick y

	mov	r9, #0		@ bricks drawn

	loopGrid:
		loopTen:	
			ldrb	r11, [r6], #1
			cmp	r9, #10
			bne	compThree
			
			mov	r0, #659
			add	r1, #32
			sub	r9, #10			
	
		compThree:
			cmp	r11, #3
			bne	compTwo
			
			ldr	r2, =0xFFFF0005
			push	{r0-r4}
			bl	DrawBrick
			pop	{r0-r4}

			b	gridNext

		compTwo:
			cmp	r11, #2
			bne	compOne
			
			ldr	r2, =0xFF3B39FF
			push	{r0-r4}
			bl	DrawBrick
			pop	{r0-r4}

			b	gridNext

		compOne:
			cmp	r11, #1
			bne	compZero
			
			ldr	r2, =0xFF00FF00
			push	{r0-r4}
			bl	DrawBrick
			pop	{r0-r4}
			
			b	gridNext

		compZero:
			cmp	r11, #0
			bne	gridNext
			
			add	r0, #59
		
	gridNext:
		add	r9, #1
		add	r0, #60
		cmp	r5, r6			//reached end of array?
		bne 	loopGrid		//loop until reach array end
		popeq 	{lr}
		moveq	pc, lr
	
@ DrawBrick
@ r0 - x
@ r1 - y
@ r2 - color

.globl	DrawBrick
DrawBrick:
	push	{lr}

	add	r3, r0, #59
	add	r4, r1, #30

	loopBrick:
		cmp	r0, r3
		bge	brickNext

		push	{r0-r4}
		bl	DrawPixel
		pop	{r0-r4}

		add	r0, #1
		b 	loopBrick

	brickNext:
		sub	r0, #59
		add	r1, #1
		cmp	r1, r4
		popeq	{lr}
		moveq	pc, lr
		b	loopBrick

@ DrawPowerOne
@ r0 - x
@ r1 - y

.globl	DrawPowerOne
DrawPowerOne:
	push	{lr}

	add	r3, r0, #20
	add	r4, r1, #20

	loopPowerOne:
		cmp	r0, r3
		bge	powerOneNext
		
		ldr	r2, =0xFF31FEFF
		push	{r0-r4}
		bl	DrawPixel
		pop	{r0-r4}

		add	r0, #1
		b 	loopPowerOne

	powerOneNext:
		sub	r0, #59
		add	r1, #1
		cmp	r1, r4
		popeq	{lr}
		moveq	pc, lr
		b	loopPowerOne

@ DrawPowerTwo
@ r0 - x
@ r1 - y

.globl	DrawPowerTwo
DrawPowerTwo:
	push	{lr}

	add	r3, r0, #20
	add	r4, r1, #20

	loopPowerTwo:
		cmp	r0, r3
		bge	powerTwoNext

		ldr	r2, =0xFFFD43FF
		push	{r0-r4}
		bl	DrawPixel
		pop	{r0-r4}

		add	r0, #1
		b 	loopPowerTwo

	powerTwoNext:
		sub	r0, #59
		add	r1, #1
		cmp	r1, r4
		popeq	{lr}
		moveq	pc, lr
		b	loopPowerTwo

@ Data section
.section	.data

.globl	brick_lives
brick_lives:	.byte	3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
endBrickLives:
.align

