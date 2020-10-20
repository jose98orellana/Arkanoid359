.section	.text

.globl	draw_menu
draw_menu:
	push	{lr}

	bl	DrawMenuBack

	ldr	r2, =0xFFFFFD00
	bl	printGameName

	ldr	r2, =0xFFFF0004
	bl	startSG
	bl	startQG
	
	bl	namesLabel

	popeq	{lr}
	moveq	pc, lr

.globl	DrawMenuBack
DrawMenuBack:
	push	{lr}

	mov	r0, #659
	mov	r1, #200

	add	r3, r0, #640
	add	r4, r1, #640

	loopMenu:
		cmp	r0, r3
		bge	menuNext
		
		ldr	r2, =0xFF000000
		push	{r0-r4}
		bl	DrawPixel
		pop	{r0-r4}

		add	r0, #1
		b loopMenu

	menuNext:
		sub	r0, #640
		add	r1, #1
		cmp	r1, r4
		popeq	{lr}
		moveq	pc, lr
		b	loopMenu
