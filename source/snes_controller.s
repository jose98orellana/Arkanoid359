@.text section
.section .text

// assembly operator alignment to 4 bytes
.align 4
.global get_input
.global check_a_button
.global check_b_button
.global check_start_button
.global check_up_button
.global check_down_button
.global check_left_button
.global check_right_button

// get_input function
//  Getting the inputs from SNES controller
// Return value:
//  r0 - the code of pressed button
get_input:
	// push and save the value of all callee-save registers to stack
	push	{r6, r7, r8, lr}
	
	// set up the mask 0
	mov	r6, #0
	// set up the mask 1
	mov	r7, #1
	// set up the upper limit
	mov	r8, #12

    checkReadButton:
	// read the buttons
	bl	Read_SNES
	// shift out the 4 unused bits
	// the result is in the r0
	lsr	r0, r0, #4

	// pop the saved value of all callee-save registers from stack
	pop	{r6, r7, r8, pc}
	
// check_a_button function
//  Checking the A button status from SNES controller
// Return value:
//  r0 - a boolean value, 0 is false, 1 is true
//  0 means The button is not pressed
//  1 means The button is pressed
check_a_button:
	// push and save the value of all callee-save registers to stack
	push	{r4, r5, lr}
	
	// get the button status from snes
	bl get_input
	
	// logical shift right 3 bits
	lsr	r0, #3
	
	// set up the mask 0
	mov	r4, #0
	// set up the mask 1
	mov	r5, #1
	
	// check the right most bit with mask 0
	and	r0, r0, r5
	teq	r0, r4
	moveq r0, #1
	movne r0, #0
	
	// pop the saved value of all callee-save registers from stack
	pop	{r4, r5, pc}
	
// check_b_button function
//  Checking the B button status from SNES controller
// Return value:
//  r0 - a boolean value, 0 is false, 1 is true
//  0 means The button is not pressed
//  1 means The button is pressed
check_b_button:
	// push and save the value of all callee-save registers to stack
	push	{r4, r5, lr}
	
	// get the button status from snes
	bl get_input
	
	// logical shift right 11 bits
	lsr	r0, #11
	
	// set up the mask 0
	mov	r4, #0
	// set up the mask 1
	mov	r5, #1
	
	// check the right most bit with mask 0
	and	r0, r0, r5
	teq	r0, r4
	moveq r0, #1
	movne r0, #0
	
	// pop the saved value of all callee-save registers from stack
	pop	{r4, r5, pc}
	
// check_start_button function
//  Checking the Start button status from SNES controller
// Return value:
//  r0 - a boolean value, 0 is false, 1 is true
//  0 means The button is not pressed
//  1 means The button is pressed
check_start_button:
	// push and save the value of all callee-save registers to stack
	push	{r4, r5, lr}
	
	// get the button status from snes
	bl get_input
	
	// logical shift right 8 bits
	lsr	r0, #8
	
	// set up the mask 0
	mov	r4, #0
	// set up the mask 1
	mov	r5, #1
	
	// check the right most bit with mask 0
	and	r0, r0, r5
	teq	r0, r4
	moveq r0, #1
	movne r0, #0
	
	// pop the saved value of all callee-save registers from stack
	pop	{r4, r5, pc}
	
// check_up_button function
//  Checking the Up button status from SNES controller
// Return value:
//  r0 - a boolean value, 0 is false, 1 is true
//  0 means The button is not pressed
//  1 means The button is pressed
check_up_button:
	// push and save the value of all callee-save registers to stack
	push	{r4, r5, lr}
	
	// get the button status from snes
	bl get_input
	
	// logical shift right 7 bits
	lsr	r0, #7
	
	// set up the mask 0
	mov	r4, #0
	// set up the mask 1
	mov	r5, #1
	
	// check the right most bit with mask 0
	and	r0, r0, r5
	teq	r0, r4
	moveq r0, #1
	movne r0, #0
	
	// pop the saved value of all callee-save registers from stack
	pop	{r4, r5, pc}
	
// check_down_button function
//  Checking the Down button status from SNES controller
// Return value:
//  r0 - a boolean value, 0 is false, 1 is true
//  0 means The button is not pressed
//  1 means The button is pressed
check_down_button:
	// push and save the value of all callee-save registers to stack
	push	{r4, r5, lr}
	
	// get the button status from snes
	bl get_input
	
	// logical shift right 6 bits
	lsr	r0, #6
	
	// set up the mask 0
	mov	r4, #0
	// set up the mask 1
	mov	r5, #1
	
	// check the right most bit with mask 0
	and	r0, r0, r5
	teq	r0, r4
	moveq r0, #1
	movne r0, #0
	
	// pop the saved value of all callee-save registers from stack
	pop	{r4, r5, pc}
	
// check_left_button function
//  Checking the Left button status from SNES controller
// Return value:
//  r0 - a boolean value, 0 is false, 1 is true
//  0 means The button is not pressed
//  1 means The button is pressed
check_left_button:
	// push and save the value of all callee-save registers to stack
	push	{r4, r5, lr}
	
	// get the button status from snes
	bl get_input
	
	// logical shift right 5 bits
	lsr	r0, #5
	
	// set up the mask 0
	mov	r4, #0
	// set up the mask 1
	mov	r5, #1
	
	// check the right most bit with mask 0
	and	r0, r0, r5
	teq	r0, r4
	moveq r0, #1
	movne r0, #0
	
	// pop the saved value of all callee-save registers from stack
	pop	{r4, r5, pc}
	
// check_right_button function
//  Checking the Right button status from SNES controller
// Return value:
//  r0 - a boolean value, 0 is false, 1 is true
//  0 means The button is not pressed
//  1 means The button is pressed
check_right_button:
	// push and save the value of all callee-save registers to stack
	push	{r4, r5, lr}
	
	// get the button status from snes
	bl get_input
	
	// logical shift right 4 bits
	lsr	r0, #4
	
	// set up the mask 0
	mov	r4, #0
	// set up the mask 1
	mov	r5, #1
	
	// check the right most bit with mask 0
	and	r0, r0, r5
	teq	r0, r4
	moveq r0, #1
	movne r0, #0
	
	// pop the saved value of all callee-save registers from stack
	pop	{r4, r5, pc}
	