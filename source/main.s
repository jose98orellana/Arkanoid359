// Created by
//  Jose Orellana
//  Zilin Ye

.section	.text
.global main
main:
	ldr	r0, =frameBufferInfo
	bl 	initFbInfo
	bl	Init_GPIO_ADDRESS
	bl	reset_game_vars
	bl	run_game_loop
