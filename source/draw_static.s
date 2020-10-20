.section	.text
.globl	draw_static
draw_static:
	
	bl	DrawBackground
	bl	DrawBoundaries
	bl	startLives
	bl	startScore

	stopStatic:
		b	stopStatic

@ DrawBackground

.globl	DrawBackground
DrawBackground:
	push	{r6-r9, lr}

	x	.req	r6
	y	.req	r7
	height	.req	r8
	width	.req	r9	

	mov	x, #659
	mov	y, #59
	mov	height, #1000
	mov	width, #600
	
	mov	r10, #0			@ pixels drawn
	mov	r11, #0
	
	drawLoopBg:
		cmp 	r10, height
		bge	doneBg
		b	innerLoopBg
	
	innerLoopBg:
		cmp	r11, width
		bge	contLoopBg
	
		mov	r0, x
		mov	r1, y
		ldr	r2, =0xFF000000
		bl	DrawPixel

		add	r11, #1
		add	x, #1		@ move to the next pixel on x-axis
		b	innerLoopBg

	contLoopBg:
		mov	r11, #0
		add	r10, #1
		add	y, #1
		mov	x, #659
		b	drawLoopBg
			
	doneBg:
		.unreq	x
		.unreq	y
		.unreq	height
		.unreq	width
	
	popeq	{r6-r9, lr}
	moveq	pc, lr

@ DrawBoundaries

.globl	DrawBoundaries
DrawBoundaries:
	push	{lr}
	
	// Draw top
	mov	r0, #639
	mov	r1, #0
	ldr	r2, =0xFFBDBBBC
	bl	drawBoundaryTop

	// Draw Bottom
	mov	r0, #639
	mov	r1, #1059
	ldr	r2, =0xFFBDBBBC
	bl	drawBoundaryBottom

	// Draw Left
	mov	r0, #639
	mov	r1, #59
	ldr	r2, =0xFFBDBBBC
	bl	drawBoundaryLeftRight

	// Draw Right
	mov	r0, #1259
	mov	r1, #59
	ldr	r2, =0xFFBDBBBC	
	bl	drawBoundaryLeftRight

	pop 	{lr}
	mov	pc, lr

@ Draw Top of Border

drawBoundaryTop:
	push {lr}
	add r3, r0, #640
	add r4, r1, #59

	loopTop:
		cmp	r0, r3
		bge	topNext

		push	{r0-r4}
		bl	DrawPixel
		pop	{r0-r4}

		add	r0, #1
		b loopTop

	topNext:
		sub	r0, #640
		add	r1, #1
		cmp	r1, r4
		popeq	{lr}
		moveq	pc, lr
		b	loopTop

@ Draw Bottom of Border

drawBoundaryBottom:
	push {lr}
	add r3, r0, #640
	add r4, r1, #20

	loopBottom:
		cmp	r0, r3
		bge	bottomNext

		push	{r0-r4}
		bl	DrawPixel
		pop	{r0-r4}

		add	r0, #1
		b loopBottom

	bottomNext:
		sub	r0, #640
		add	r1, #1
		cmp	r1, r4
		popeq	{lr}
		moveq	pc, lr
		b	loopBottom

@ Draw Top/Bottom of Border

drawBoundaryLeftRight:
	push {lr}
	add r3, r0, #20
	add r4, r1, #1000

	loopLeft:
		cmp	r0, r3
		bge	leftNext

		push	{r0-r4}
		bl	DrawPixel
		pop	{r0-r4}

		add	r0, #1
		b loopLeft

	leftNext:
		sub	r0, #20
		add	r1, #1
		cmp	r1, r4
		popeq	{lr}
		moveq	pc, lr
		b	loopLeft

.globl drawLoseImage
drawLoseImage: 
	push	{lr}
	
	bl	DrawPauseBack
	bl	printLose

	pop	{lr}
	mov	pc, lr

.globl drawWinImage
drawWinImage: 
	push	{lr}

	bl	DrawPauseBack
	bl	printWin

	pop	{lr}
	mov	pc, lr

.globl drawGameOver
drawGameOver: 
	push	{lr}

	bl	DrawPauseBack
	bl	printOver

	pop	{lr}
	mov	pc, lr

.globl clearScreen
clearScreen:
	push 		{lr}

	mov		r0, #0
	mov 		r1, #0
	ldr		r2, =0xFFFCFFFE
	
	ldr	r8, =#1919
	ldr	r9, =#1079
	add		r3, r0, r8		//r3 = final x coordinate
	add 		r4, r1, r9		//r4 = final y coordinate
loopClear:				
	cmp		r0, r3		
	bge		clearNext

	push		{r0-r4}
	bl 		DrawPixel
	pop		{r0-r4}

	add		r0, #1
	b		loopClear

clearNext: 
	sub		r0, r8			//r0 = original x coordinate
	add		r1, #1
	cmp 		r1, r4 		
	popeq		{lr}
	moveq 		pc, lr
	b 		loopClear
	
	pop		{lr}
	mov 		pc, lr

.globl clearScreenP
clearScreenP:
	push 		{lr}

	mov		r0, #0
	mov 		r1, #0
	ldr		r2, =0xFFFCFFFE
	
	ldr	r8, =#1919
	ldr	r9, =#1079
	add		r3, r0, r8		//r3 = final x coordinate
	add 		r4, r1, r9		//r4 = final y coordinate
loopClearP:				
	cmp		r0, r3		
	bge		clearNextP

	push		{r0-r4}
	bl 		DrawPixel
	pop		{r0-r4}

	add		r0, #1
	b		loopClearP

clearNextP: 
	sub		r0, r8			//r0 = original x coordinate
	add		r1, #1
	cmp 		r1, r4 		
	popeq		{lr}
	moveq 		pc, lr
	b 		loopClearP
	
	pop		{lr}
	mov 		pc, lr

.globl	DrawPauseBack
DrawPauseBack:
	push	{lr}

	mov	r0, #659
	mov	r1, #200

	add	r3, r0, #640
	add	r4, r1, #640

	loopPause:
		cmp	r0, r3
		bge	pauseNext
		
		ldr	r2, =0xFF000000
		push	{r0-r4}
		bl	DrawPixel
		pop	{r0-r4}

		add	r0, #1
		b loopPause

	pauseNext:
		sub	r0, #640
		add	r1, #1
		cmp	r1, r4
		popeq	{lr}
		moveq	pc, lr
		b	loopPause
