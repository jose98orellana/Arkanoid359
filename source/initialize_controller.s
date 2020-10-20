@.data section
.section .data

// address alignment to 2 bytes
.align 2
.global gpioBaseAddress
gpioBaseAddress:
	.int	0

@.text section
.section .text

// assembly operator alignment to 4 bytes
.align 4
.global Read_SNES
.global Init_GPIO_ADDRESS

// Init_GPIO_ADDRESS function
//  initialize the GPIO base address
//  warning: This should be called before any other function.
//           And it should be only called once
Init_GPIO_ADDRESS:
	push	{lr}
	// Get GPIO base address and store in memory for future use
	
	bl	getGpioPtr		
	ldr	r1, =gpioBaseAddress
	str	r0, [r1]
	
	pop	{pc}

// Init_GPIO function
//  initialize the GPIO function from setting
//   r0 - pin number of GPIO
//   r1 - function code want to set
Init_GPIO:
	// push and save the value of all callee-save registers to stack
	push	{r4, r5, r6, r7, r8, r9, r10, lr}

	// set rgeister alias
	gPin	.req	r0
	gFun	.req	r1
	gRegAdd	.req	r3
	gRegCon .req	r4
	gMask	.req	r5
	gBase	.req	r6

	// save GPIO address to a local variable
	ldr	r2, =gpioBaseAddress
	ldr	gBase, [r2]

	// to determine which section of GPIOSEL register we will process
	cmp	gPin, #9
	beq	Init_GPIO_SEL0
	cmp	gPin, #10
	beq	Init_GPIO_SEL1
	cmp	gPin, #11
	beq	Init_GPIO_SEL1

    // Set the address of GPFSELx
    Init_GPIO_SEL0:
	mov	gRegAdd, gBase
	b	Init_SET_GPFSEL
    Init_GPIO_SEL1:
	add	gRegAdd, gBase, #0x04
	b	Init_SET_GPFSEL

    Init_SET_GPFSEL:
	// copy GPFSELx into r4
	ldr	gRegCon, [gRegAdd]
	// mov mask b0111 to r5
	mov	gMask, #7
	
	cmp	gPin, #9
	beq	Init_SET_PIN9
	cmp	gPin, #10
	beq	Init_SET_PIN10
	cmp	gPin, #11
	beq	Init_SET_PIN11
	
	// shift the mask and func code to PINx
	Init_SET_PIN9:
	lsl	gMask, #27
	lsl	gFun, #27
	b	Init_SET_FUN
	Init_SET_PIN10:
	lsl	gMask, #0
	lsl	gFun, #0
	b	Init_SET_FUN
	Init_SET_PIN11:
	lsl	gMask, #3
	lsl	gFun, #3
	b	Init_SET_FUN

	Init_SET_FUN:
	// Clear PINx bits
	bic	gRegCon, gMask
	// Set the function
	orr	gRegCon, gFun
	// write back to GPSELx
	str	gRegCon, [gRegAdd]
	
	// pop the saved value of all callee-save registers from stack
	pop	{r4, r5, r6, r7, r8, r9, r10, pc}

// Write_Latch function
//  Write a bit to the SNES latch line
//   r0 - a bit want to write
Write_Latch:
	// push and save the value of all callee-save registers to stack
	push	{r4, r5, r6, r7, r8, r9, r10, lr}
	
	// save bit to r4
	mov	r4, r0
	// set pin# to 9
	mov	r0, #9
	// set the function to write
	mov	r1, #1
	bl	Init_GPIO

	// set pin# to 9
	mov	r0, #9
	// save GPIO address to a local variable
	ldr	r1, =gpioBaseAddress
	ldr	gBase, [r1]
	// set bit mask
	mov	r2, #1
	// shift to the correct pin#
	lsl	r2, r0
	// check if the bit is set
	teq	r4, #0
	// GPCLR0 = 0
	streq	r2, [gBase, #40]
	// GPSET0 = 1
	strne	r2, [gBase, #28]

	// pop the saved value of all callee-save registers from stack
	pop	{r4, r5, r6, r7, r8, r9, r10, pc}

// Write_Clock function
//  Write a bit to the SNES clock line
//   r0 - a bit want to write
Write_Clock:
	// push and save the value of all callee-save registers to stack
	push	{r4, r5, r6, r7, r8, r9, r10, lr}

	// save bit to r4
	mov	r4, r0
	// set pin# to 11
	mov	r0, #11
	// set the function to write
	mov	r1, #1
	bl	Init_GPIO

	// set pin# to 11
	mov	r0, #11
	// save GPIO address to a local variable
	ldr	r1, =gpioBaseAddress
	ldr	gBase, [r1]
	// set bit mask
	mov	r2, #1
	// shift to the correct pin#
	lsl	r2, r0
	// check if the bit is set
	teq	r4, #0
	// GPCLR0 if r4 = 0
	streq	r2, [gBase, #40]
	// GPSET0 if r4 = 1
	strne	r2, [gBase, #28]

	// pop the saved value of all callee-save registers from stack
	pop	{r4, r5, r6, r7, r8, r9, r10, pc}

// Read_Data function
//  Read a bit from the SNES data line
// Return value:
//   r0 - read bit from SNES data line
Read_Data:
	// push and save the value of all callee-save registers to stack
	push	{r4, r5, r6, r7, r8, r9, r10, lr}

	// set pin# to 10
	mov	r0, #10
	// set the function to read
	mov	r1, #0
	bl	Init_GPIO

	// set pin# to 10
	mov	r0, #10
	// save GPIO address to a local variable
	ldr	r1, =gpioBaseAddress
	ldr	gBase, [r1]
	// r2 = GPLEV0
	ldr	r2, [gBase, #52]
	// set bit mask
	mov	r3, #1
	// shift to the correct pin#
	lsl	r3, r0
	// mask everything else
	and	r2, r3
	teq	r2, #0
	// return 0
	moveq	r0, #0
	// return 1
	movne	r0, #1

	// pop the saved value of all callee-save registers from stack
	pop	{r4, r5, r6, r7, r8, r9, r10, pc}

// Read_SNES function
//  read the input from a SNES controller, and returns a code of pressed
//  button in r0
// Return value:
//  r0 - the code of pressed button
Read_SNES:
	// push and save the value of all callee-save registers to stack
	push	{r4, r5, r6, r7, r8, r9, r10, lr}

	// set up the buttons to 0
	mov	r4, #0
	// write 1 to clock
	mov	r0, #1
	bl	Write_Clock
	// write 1 to latch
	mov	r0, #1
	bl	Write_Latch
	// wait for 12 us
	mov	r0, #12
	bl	delayMicroseconds
	// write 0 to latch
	mov	r0, #0
	bl	Write_Latch
	// set up the counter r5 = 0
	mov	r5, #0
	// set up the upper limit
	mov	r6, #16
    pulseLoop:
	// wait for 6 us
	mov	r0, #6
	bl	delayMicroseconds
	// falling edge
	mov	r0, #0
	bl	Write_Clock
	// wait for 6 us
	mov	r0, #6
	bl	delayMicroseconds
	// read current button status
	bl	Read_Data
	// shift 1 bit to the left of buttons register
	lsl	r4, #1
	// save it to the right most bit
	orr	r4, r0
	// new cycle of rising edge
	mov	r0, #1
	bl	Write_Clock
	// counter++
	add	r5, r5, #1
	// check i < 16
	cmp	r5, #16
	blt	pulseLoop
	
	//once its finished, return the button map
	mov	r0, r4

	// pop the saved value of all callee-save registers from stack
	pop	{r4, r5, r6, r7, r8, r9, r10, pc}
