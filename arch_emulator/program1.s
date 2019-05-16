	.arch armv6
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"program1.c"
	.comm	mem,300,4
	.comm	tb_mem,300,4
	.comm	corr,100,4
	.comm	corr_mem,100,4
	.section	.rodata
	.align	2
.LC0:
	.ascii	"\012Num Errors: %d\000"
	.align	2
.LC1:
	.ascii	"\012Num Errors: %d\011All Tests Passed!\012\000"
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu vfp
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	bl	fill_mem
	bl	fec_encode
	bl	fec_corruptor
	ldr	r3, [fp, #-20]
	add	r3, r3, #4
	ldr	r3, [r3]
	mov	r0, r3
	bl	atoi
	mov	r3, r0
	uxtb	r3, r3
	mov	r0, r3
	bl	fec_decode
	bl	checkMem
	str	r0, [fp, #-8]
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	ble	.L2
	ldr	r3, .L5
	ldr	r3, [r3]
	ldr	r2, [fp, #-8]
	ldr	r1, .L5+4
	mov	r0, r3
	bl	fprintf
	b	.L3
.L2:
	ldr	r1, [fp, #-8]
	ldr	r0, .L5+8
	bl	printf
.L3:
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
.L6:
	.align	2
.L5:
	.word	stderr
	.word	.LC0
	.word	.LC1
	.size	main, .-main
	.section	.rodata
	.align	2
.LC2:
	.ascii	"\012Memory Results\000"
	.align	2
.LC3:
	.ascii	"=========================\000"
	.align	2
.LC4:
	.ascii	"mem[%d] = 0x%.2X\012\000"
	.align	2
.LC5:
	.ascii	"\012Test Bench Memory Results\000"
	.align	2
.LC6:
	.ascii	"tb_mem[%d] = 0x%.2X\012\000"
	.align	2
.LC7:
	.ascii	"\012Corruption\000"
	.align	2
.LC8:
	.ascii	"corr[%d] = 0x%.2X\012\000"
	.text
	.align	2
	.global	printMem
	.syntax unified
	.arm
	.fpu vfp
	.type	printMem, %function
printMem:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	ldr	r0, .L14
	bl	puts
	ldr	r0, .L14+4
	bl	puts
	ldr	r3, .L14+8
	str	r3, [fp, #-8]
	b	.L8
.L9:
	ldr	r2, .L14+12
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r2, r3
	ldr	r1, [fp, #-8]
	ldr	r0, .L14+16
	bl	printf
	ldr	r3, [fp, #-8]
	sub	r3, r3, #1
	str	r3, [fp, #-8]
.L8:
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	bge	.L9
	ldr	r0, .L14+20
	bl	puts
	ldr	r0, .L14+4
	bl	puts
	ldr	r3, .L14+8
	str	r3, [fp, #-8]
	b	.L10
.L11:
	ldr	r2, .L14+24
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r2, r3
	ldr	r1, [fp, #-8]
	ldr	r0, .L14+28
	bl	printf
	ldr	r3, [fp, #-8]
	sub	r3, r3, #1
	str	r3, [fp, #-8]
.L10:
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	bge	.L11
	ldr	r0, .L14+32
	bl	puts
	ldr	r0, .L14+4
	bl	puts
	mov	r3, #99
	str	r3, [fp, #-8]
	b	.L12
.L13:
	ldr	r2, .L14+36
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r2, r3
	ldr	r1, [fp, #-8]
	ldr	r0, .L14+40
	bl	printf
	ldr	r3, [fp, #-8]
	sub	r3, r3, #1
	str	r3, [fp, #-8]
.L12:
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	bge	.L13
	nop
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
.L15:
	.align	2
.L14:
	.word	.LC2
	.word	.LC3
	.word	299
	.word	mem
	.word	.LC4
	.word	.LC5
	.word	tb_mem
	.word	.LC6
	.word	.LC7
	.word	corr
	.word	.LC8
	.size	printMem, .-printMem
	.align	2
	.global	fec_encode
	.syntax unified
	.arm
	.fpu vfp
	.type	fec_encode, %function
fec_encode:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L17
.L18:
	ldr	r3, [fp, #-8]
	add	r3, r3, #101
	ldr	r2, [fp, #-8]
	add	r2, r2, #1
	ldr	r1, .L19
	ldrb	r2, [r1, r2]	@ zero_extendqisi2
	lsl	r2, r2, #4
	sxtb	r1, r2
	ldr	r0, .L19
	ldr	r2, [fp, #-8]
	add	r2, r0, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	lsr	r2, r2, #4
	uxtb	r2, r2
	sxtb	r2, r2
	orr	r2, r1, r2
	sxtb	r2, r2
	uxtb	r1, r2
	ldr	r2, .L19
	strb	r1, [r2, r3]
	ldr	r3, [fp, #-8]
	add	r3, r3, #101
	ldr	r2, .L19
	ldrb	r3, [r2, r3]	@ zero_extendqisi2
	mov	r0, r3
	bl	xor_bits
	mov	r3, r0
	strb	r3, [fp, #-9]
	ldr	r2, .L19
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	asr	r3, r3, #1
	sxtb	r3, r3
	and	r3, r3, #7
	sxtb	r2, r3
	ldr	r1, .L19
	ldr	r3, [fp, #-8]
	add	r3, r1, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	asr	r3, r3, #4
	sxtb	r3, r3
	and	r3, r3, #8
	sxtb	r3, r3
	orr	r3, r2, r3
	sxtb	r2, r3
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	ldr	r1, .L19
	ldrb	r3, [r1, r3]	@ zero_extendqisi2
	lsl	r3, r3, #4
	sxtb	r3, r3
	orr	r3, r2, r3
	sxtb	r3, r3
	uxtb	r3, r3
	mov	r0, r3
	bl	xor_bits
	mov	r3, r0
	strb	r3, [fp, #-10]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	ldr	r2, .L19
	ldrb	r3, [r2, r3]	@ zero_extendqisi2
	lsl	r3, r3, #5
	sxtb	r3, r3
	bic	r3, r3, #63
	sxtb	r2, r3
	ldr	r1, .L19
	ldr	r3, [fp, #-8]
	add	r3, r1, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	asr	r3, r3, #1
	sxtb	r3, r3
	and	r3, r3, #48
	sxtb	r3, r3
	orr	r3, r2, r3
	sxtb	r2, r3
	ldr	r1, .L19
	ldr	r3, [fp, #-8]
	add	r3, r1, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	sxtb	r3, r3
	and	r3, r3, #13
	sxtb	r3, r3
	orr	r3, r2, r3
	sxtb	r3, r3
	uxtb	r3, r3
	mov	r0, r3
	bl	xor_bits
	mov	r3, r0
	strb	r3, [fp, #-11]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	ldr	r2, .L19
	ldrb	r3, [r2, r3]	@ zero_extendqisi2
	lsl	r3, r3, #5
	sxtb	r3, r3
	bic	r3, r3, #127
	sxtb	r2, r3
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	ldr	r1, .L19
	ldrb	r3, [r1, r3]	@ zero_extendqisi2
	lsl	r3, r3, #6
	sxtb	r3, r3
	and	r3, r3, #64
	sxtb	r3, r3
	orr	r3, r2, r3
	sxtb	r2, r3
	ldr	r1, .L19
	ldr	r3, [fp, #-8]
	add	r3, r1, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	asr	r3, r3, #1
	sxtb	r3, r3
	and	r3, r3, #32
	sxtb	r3, r3
	orr	r3, r2, r3
	sxtb	r2, r3
	ldr	r1, .L19
	ldr	r3, [fp, #-8]
	add	r3, r1, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	sxtb	r3, r3
	and	r3, r3, #16
	sxtb	r3, r3
	orr	r3, r2, r3
	sxtb	r2, r3
	ldr	r1, .L19
	ldr	r3, [fp, #-8]
	add	r3, r1, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	sxtb	r3, r3
	and	r3, r3, #11
	sxtb	r3, r3
	orr	r3, r2, r3
	sxtb	r3, r3
	uxtb	r3, r3
	mov	r0, r3
	bl	xor_bits
	mov	r3, r0
	strb	r3, [fp, #-12]
	ldr	r3, [fp, #-8]
	add	r3, r3, #100
	ldrb	r2, [fp, #-9]	@ zero_extendqisi2
	lsl	r2, r2, #7
	sxtb	r1, r2
	ldr	r0, .L19
	ldr	r2, [fp, #-8]
	add	r2, r0, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	lsl	r2, r2, #3
	sxtb	r2, r2
	and	r2, r2, #112
	sxtb	r2, r2
	orr	r2, r1, r2
	sxtb	r1, r2
	ldrb	r2, [fp, #-10]	@ zero_extendqisi2
	lsl	r2, r2, #3
	sxtb	r2, r2
	orr	r2, r1, r2
	sxtb	r1, r2
	ldr	r0, .L19
	ldr	r2, [fp, #-8]
	add	r2, r0, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	lsl	r2, r2, #2
	sxtb	r2, r2
	and	r2, r2, #4
	sxtb	r2, r2
	orr	r2, r1, r2
	sxtb	r1, r2
	ldrb	r2, [fp, #-11]	@ zero_extendqisi2
	lsl	r2, r2, #1
	sxtb	r2, r2
	orr	r2, r1, r2
	sxtb	r1, r2
	ldrsb	r2, [fp, #-12]
	orr	r2, r1, r2
	sxtb	r2, r2
	uxtb	r1, r2
	ldr	r2, .L19
	strb	r1, [r2, r3]
	ldr	r3, [fp, #-8]
	add	r3, r3, #2
	str	r3, [fp, #-8]
.L17:
	ldr	r3, [fp, #-8]
	cmp	r3, #99
	ble	.L18
	nop
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
.L20:
	.align	2
.L19:
	.word	mem
	.size	fec_encode, .-fec_encode
	.align	2
	.global	fec_corruptor
	.syntax unified
	.arm
	.fpu vfp
	.type	fec_corruptor, %function
fec_corruptor:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #12
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L22
.L23:
	ldr	r3, [fp, #-8]
	add	r3, r3, #101
	ldr	r2, .L24
	ldrb	r3, [r2, r3]
	strb	r3, [fp, #-9]
	ldr	r3, [fp, #-8]
	add	r3, r3, #100
	ldr	r2, .L24
	ldrb	r3, [r2, r3]
	strb	r3, [fp, #-10]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	ldr	r2, .L24+4
	ldrb	r3, [r2, r3]
	strb	r3, [fp, #-11]
	ldr	r2, .L24+4
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-12]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	ldrb	r1, [fp, #-11]
	ldrb	r2, [fp, #-9]
	eor	r2, r2, r1
	uxtb	r1, r2
	ldr	r2, .L24+8
	strb	r1, [r2, r3]
	ldrb	r2, [fp, #-12]
	ldrb	r3, [fp, #-10]
	eor	r3, r3, r2
	uxtb	r1, r3
	ldr	r2, .L24+8
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [fp, #-8]
	add	r3, r3, #2
	str	r3, [fp, #-8]
.L22:
	ldr	r3, [fp, #-8]
	cmp	r3, #99
	ble	.L23
	nop
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
.L25:
	.align	2
.L24:
	.word	mem
	.word	corr
	.word	corr_mem
	.size	fec_corruptor, .-fec_corruptor
	.section	.rodata
	.align	2
.LC9:
	.ascii	"\012**************\012Error Summary\012************"
	.ascii	"**\000"
	.align	2
.LC10:
	.ascii	"Error at mem[%d]\011result: 0x%.2X\011expected: 0x%"
	.ascii	".2X\012\000"
	.text
	.align	2
	.global	checkMem
	.syntax unified
	.arm
	.fpu vfp
	.type	checkMem, %function
checkMem:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	mov	r3, #0
	str	r3, [fp, #-12]
	ldr	r0, .L31
	bl	puts
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L27
.L29:
	ldr	r2, .L31+4
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r2, [r3]	@ zero_extendqisi2
	ldr	r1, .L31+8
	ldr	r3, [fp, #-8]
	add	r3, r1, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r2, r3
	beq	.L28
	ldr	r3, .L31+12
	ldr	r0, [r3]
	ldr	r2, .L31+4
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r1, r3
	ldr	r2, .L31+8
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	str	r3, [sp]
	mov	r3, r1
	ldr	r2, [fp, #-8]
	ldr	r1, .L31+16
	bl	fprintf
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]
.L28:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L27:
	ldr	r3, [fp, #-8]
	cmp	r3, #300
	blt	.L29
	ldr	r3, [fp, #-12]
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
.L32:
	.align	2
.L31:
	.word	.LC9
	.word	mem
	.word	tb_mem
	.word	stderr
	.word	.LC10
	.size	checkMem, .-checkMem
	.align	2
	.global	fec_decode
	.syntax unified
	.arm
	.fpu vfp
	.type	fec_decode, %function
fec_decode:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #40
	mov	r3, r0
	strb	r3, [fp, #-37]
	mov	r3, #100
	str	r3, [fp, #-16]
	mov	r3, #200
	str	r3, [fp, #-24]
	ldr	r3, .L39
	str	r3, [fp, #-20]
	ldrb	r3, [fp, #-37]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L34
	ldr	r3, .L39+4
	str	r3, [fp, #-20]
	mov	r3, #0
	str	r3, [fp, #-16]
.L34:
	mov	r3, #0
	str	r3, [fp, #-12]
	b	.L35
.L38:
	ldr	r3, [fp, #-12]
	add	r2, r3, #1
	ldr	r3, [fp, #-16]
	add	r3, r2, r3
	mov	r2, r3
	ldr	r3, [fp, #-20]
	add	r3, r3, r2
	ldrb	r3, [r3]
	strb	r3, [fp, #-5]
	ldr	r2, [fp, #-12]
	ldr	r3, [fp, #-16]
	add	r3, r2, r3
	mov	r2, r3
	ldr	r3, [fp, #-20]
	add	r3, r3, r2
	ldrb	r3, [r3]
	strb	r3, [fp, #-6]
	mov	r3, #0
	strb	r3, [fp, #-25]
	mov	r3, #0
	strb	r3, [fp, #-26]
	mov	r3, #0
	strb	r3, [fp, #-27]
	ldrb	r3, [fp, #-5]	@ zero_extendqisi2
	lsl	r3, r3, #1
	sxtb	r2, r3
	ldrb	r3, [fp, #-6]	@ zero_extendqisi2
	lsr	r3, r3, #7
	uxtb	r3, r3
	sxtb	r3, r3
	orr	r3, r2, r3
	sxtb	r3, r3
	uxtb	r3, r3
	mov	r0, r3
	bl	xor_bits
	mov	r3, r0
	strb	r3, [fp, #-28]
	ldrb	r2, [fp, #-27]
	ldrb	r3, [fp, #-28]
	eor	r3, r3, r2
	strb	r3, [fp, #-27]
	ldrb	r3, [fp, #-27]
	lsl	r3, r3, #1
	strb	r3, [fp, #-27]
	ldrb	r3, [fp, #-5]	@ zero_extendqisi2
	lsr	r3, r3, #3
	uxtb	r3, r3
	lsl	r3, r3, #4
	sxtb	r2, r3
	ldrb	r3, [fp, #-6]	@ zero_extendqisi2
	asr	r3, r3, #3
	sxtb	r3, r3
	and	r3, r3, #15
	sxtb	r3, r3
	orr	r3, r2, r3
	sxtb	r3, r3
	uxtb	r3, r3
	mov	r0, r3
	bl	xor_bits
	mov	r3, r0
	strb	r3, [fp, #-29]
	ldrb	r2, [fp, #-27]
	ldrb	r3, [fp, #-29]
	eor	r3, r3, r2
	strb	r3, [fp, #-27]
	ldrb	r3, [fp, #-27]
	lsl	r3, r3, #1
	strb	r3, [fp, #-27]
	ldrb	r3, [fp, #-5]	@ zero_extendqisi2
	lsl	r3, r3, #1
	sxtb	r3, r3
	bic	r3, r3, #63
	sxtb	r2, r3
	ldrb	r3, [fp, #-5]	@ zero_extendqisi2
	lsl	r3, r3, #3
	sxtb	r3, r3
	and	r3, r3, #48
	sxtb	r3, r3
	orr	r3, r2, r3
	sxtb	r2, r3
	ldrb	r3, [fp, #-6]	@ zero_extendqisi2
	asr	r3, r3, #3
	sxtb	r3, r3
	and	r3, r3, #12
	sxtb	r3, r3
	orr	r3, r2, r3
	sxtb	r2, r3
	ldrb	r3, [fp, #-6]	@ zero_extendqisi2
	asr	r3, r3, #1
	sxtb	r3, r3
	and	r3, r3, #3
	sxtb	r3, r3
	orr	r3, r2, r3
	sxtb	r3, r3
	uxtb	r3, r3
	mov	r0, r3
	bl	xor_bits
	mov	r3, r0
	strb	r3, [fp, #-30]
	ldrb	r2, [fp, #-27]
	ldrb	r3, [fp, #-30]
	eor	r3, r3, r2
	strb	r3, [fp, #-27]
	ldrb	r3, [fp, #-27]
	lsl	r3, r3, #1
	strb	r3, [fp, #-27]
	mov	r3, #0
	strb	r3, [fp, #-31]
	mov	r3, #0
	strb	r3, [fp, #-32]
	ldrb	r3, [fp, #-5]	@ zero_extendqisi2
	lsr	r3, r3, #6
	uxtb	r3, r3
	lsl	r3, r3, #7
	sxtb	r2, r3
	ldrsb	r3, [fp, #-31]
	orr	r3, r2, r3
	sxtb	r3, r3
	strb	r3, [fp, #-31]
	ldrb	r3, [fp, #-5]	@ zero_extendqisi2
	lsr	r3, r3, #4
	uxtb	r3, r3
	lsl	r3, r3, #7
	strb	r3, [fp, #-32]
	ldrb	r3, [fp, #-32]	@ zero_extendqisi2
	lsr	r3, r3, #1
	uxtb	r2, r3
	ldrb	r3, [fp, #-31]
	orr	r3, r2, r3
	strb	r3, [fp, #-31]
	ldrb	r3, [fp, #-5]	@ zero_extendqisi2
	lsr	r3, r3, #2
	uxtb	r3, r3
	lsl	r3, r3, #7
	strb	r3, [fp, #-32]
	ldrb	r3, [fp, #-32]	@ zero_extendqisi2
	lsr	r3, r3, #2
	uxtb	r2, r3
	ldrb	r3, [fp, #-31]
	orr	r3, r2, r3
	strb	r3, [fp, #-31]
	ldrb	r3, [fp, #-5]
	lsl	r3, r3, #7
	strb	r3, [fp, #-32]
	ldrb	r3, [fp, #-32]	@ zero_extendqisi2
	lsr	r3, r3, #3
	uxtb	r2, r3
	ldrb	r3, [fp, #-31]
	orr	r3, r2, r3
	strb	r3, [fp, #-31]
	ldrb	r3, [fp, #-6]
	lsl	r3, r3, #1
	strb	r3, [fp, #-32]
	ldrb	r3, [fp, #-32]	@ zero_extendqisi2
	lsr	r3, r3, #7
	uxtb	r3, r3
	lsl	r3, r3, #3
	sxtb	r2, r3
	ldrsb	r3, [fp, #-31]
	orr	r3, r2, r3
	sxtb	r3, r3
	strb	r3, [fp, #-31]
	ldrb	r3, [fp, #-6]
	lsl	r3, r3, #3
	strb	r3, [fp, #-32]
	ldrb	r3, [fp, #-32]	@ zero_extendqisi2
	lsr	r3, r3, #7
	uxtb	r3, r3
	lsl	r3, r3, #2
	sxtb	r2, r3
	ldrsb	r3, [fp, #-31]
	orr	r3, r2, r3
	sxtb	r3, r3
	strb	r3, [fp, #-31]
	ldrb	r3, [fp, #-6]
	lsl	r3, r3, #5
	strb	r3, [fp, #-32]
	ldrb	r3, [fp, #-32]	@ zero_extendqisi2
	lsr	r3, r3, #7
	uxtb	r3, r3
	lsl	r3, r3, #1
	sxtb	r2, r3
	ldrsb	r3, [fp, #-31]
	orr	r3, r2, r3
	sxtb	r3, r3
	strb	r3, [fp, #-31]
	ldrb	r3, [fp, #-6]
	lsl	r3, r3, #7
	strb	r3, [fp, #-32]
	ldrb	r3, [fp, #-32]	@ zero_extendqisi2
	lsr	r3, r3, #7
	uxtb	r2, r3
	ldrb	r3, [fp, #-31]
	orr	r3, r2, r3
	strb	r3, [fp, #-31]
	ldrb	r3, [fp, #-31]	@ zero_extendqisi2
	mov	r0, r3
	bl	xor_bits
	mov	r3, r0
	strb	r3, [fp, #-31]
	ldrb	r2, [fp, #-27]
	ldrb	r3, [fp, #-31]
	eor	r3, r3, r2
	strb	r3, [fp, #-27]
	ldrb	r3, [fp, #-27]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L36
	ldrb	r3, [fp, #-27]
	sub	r3, r3, #1
	strb	r3, [fp, #-27]
	ldrb	r3, [fp, #-27]
	sub	r3, r3, #8
	strb	r3, [fp, #-27]
	ldrb	r3, [fp, #-27]
	bic	r3, r3, #127
	strb	r3, [fp, #-33]
	ldrb	r3, [fp, #-33]	@ zero_extendqisi2
	lsr	r3, r3, #7
	strb	r3, [fp, #-33]
	ldrb	r3, [fp, #-33]	@ zero_extendqisi2
	cmp	r3, #0
	beq	.L37
	ldrb	r3, [fp, #-27]
	add	r3, r3, #8
	strb	r3, [fp, #-27]
	ldrb	r3, [fp, #-27]	@ zero_extendqisi2
	mov	r2, #1
	lsl	r3, r2, r3
	strb	r3, [fp, #-34]
	ldrb	r2, [fp, #-6]
	ldrb	r3, [fp, #-34]
	eor	r3, r3, r2
	strb	r3, [fp, #-6]
	b	.L36
.L37:
	ldrb	r3, [fp, #-27]	@ zero_extendqisi2
	mov	r2, #1
	lsl	r3, r2, r3
	strb	r3, [fp, #-35]
	ldrb	r2, [fp, #-5]
	ldrb	r3, [fp, #-35]
	eor	r3, r3, r2
	strb	r3, [fp, #-5]
.L36:
	ldrb	r3, [fp, #-5]	@ zero_extendqisi2
	lsr	r3, r3, #4
	uxtb	r2, r3
	ldrb	r3, [fp, #-26]
	orr	r3, r2, r3
	strb	r3, [fp, #-26]
	ldrb	r3, [fp, #-5]	@ zero_extendqisi2
	lsl	r3, r3, #4
	sxtb	r2, r3
	ldrsb	r3, [fp, #-25]
	orr	r3, r2, r3
	sxtb	r3, r3
	strb	r3, [fp, #-25]
	ldrb	r3, [fp, #-6]
	lsl	r3, r3, #1
	strb	r3, [fp, #-32]
	ldrb	r3, [fp, #-32]	@ zero_extendqisi2
	lsr	r3, r3, #5
	uxtb	r3, r3
	lsl	r3, r3, #1
	sxtb	r2, r3
	ldrsb	r3, [fp, #-25]
	orr	r3, r2, r3
	sxtb	r3, r3
	strb	r3, [fp, #-25]
	ldrb	r3, [fp, #-6]
	lsl	r3, r3, #5
	strb	r3, [fp, #-32]
	ldrb	r3, [fp, #-32]	@ zero_extendqisi2
	lsr	r3, r3, #7
	uxtb	r2, r3
	ldrb	r3, [fp, #-25]
	orr	r3, r2, r3
	strb	r3, [fp, #-25]
	ldr	r2, [fp, #-24]
	ldr	r3, [fp, #-12]
	add	r3, r2, r3
	add	r3, r3, #1
	ldr	r1, .L39
	ldrb	r2, [fp, #-26]
	strb	r2, [r1, r3]
	ldr	r2, [fp, #-24]
	ldr	r3, [fp, #-12]
	add	r3, r2, r3
	ldr	r1, .L39
	ldrb	r2, [fp, #-25]
	strb	r2, [r1, r3]
	ldr	r3, [fp, #-12]
	add	r3, r3, #2
	str	r3, [fp, #-12]
.L35:
	ldr	r3, [fp, #-12]
	cmp	r3, #99
	ble	.L38
	nop
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
.L40:
	.align	2
.L39:
	.word	mem
	.word	corr_mem
	.size	fec_decode, .-fec_decode
	.align	2
	.global	xor_bits
	.syntax unified
	.arm
	.fpu vfp
	.type	xor_bits, %function
xor_bits:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #20
	mov	r3, r0
	strb	r3, [fp, #-13]
	mov	r3, #0
	strb	r3, [fp, #-5]
	b	.L42
.L43:
	ldrsb	r3, [fp, #-13]
	and	r3, r3, #1
	sxtb	r2, r3
	ldrsb	r3, [fp, #-5]
	eor	r3, r3, r2
	sxtb	r3, r3
	strb	r3, [fp, #-5]
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	lsr	r3, r3, #1
	strb	r3, [fp, #-13]
.L42:
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L43
	ldrb	r3, [fp, #-5]	@ zero_extendqisi2
	mov	r0, r3
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
	.size	xor_bits, .-xor_bits
	.section	.rodata
	.align	2
.LC11:
	.ascii	"rb\000"
	.align	2
.LC12:
	.ascii	"prog1_2_results.txt\000"
	.align	2
.LC13:
	.ascii	"Could not open file\000"
	.text
	.align	2
	.global	fill_mem
	.syntax unified
	.arm
	.fpu vfp
	.type	fill_mem, %function
fill_mem:
	@ args = 0, pretend = 0, frame = 112
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #112
	ldr	r1, .L50
	ldr	r0, .L50+4
	bl	fopen
	str	r0, [fp, #-12]
	ldr	r3, [fp, #-12]
	cmp	r3, #0
	bne	.L46
	ldr	r3, .L50+8
	ldr	r3, [r3]
	mov	r2, #19
	mov	r1, #1
	ldr	r0, .L50+12
	bl	fwrite
	mov	r0, #1
	bl	exit
.L46:
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L47
.L48:
	sub	r3, fp, #112
	ldr	r1, [fp, #-8]
	mov	r0, r3
	bl	bits_to_buf
	ldr	r3, [fp, #-8]
	add	r3, r3, #2
	str	r3, [fp, #-8]
.L47:
	sub	r3, fp, #112
	ldr	r2, [fp, #-12]
	mov	r1, #100
	mov	r0, r3
	bl	fgets
	mov	r3, r0
	cmp	r3, #0
	bne	.L48
	ldr	r0, [fp, #-12]
	bl	fclose
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
.L51:
	.align	2
.L50:
	.word	.LC11
	.word	.LC12
	.word	stderr
	.word	.LC13
	.size	fill_mem, .-fill_mem
	.align	2
	.global	bits_to_buf
	.syntax unified
	.arm
	.fpu vfp
	.type	bits_to_buf, %function
bits_to_buf:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #20
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	mov	r3, #0
	strb	r3, [fp, #-10]
	ldrb	r3, [fp, #-10]
	strb	r3, [fp, #-9]
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L53
.L56:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #49
	bne	.L54
	ldrb	r3, [fp, #-9]
	orr	r3, r3, #1
	strb	r3, [fp, #-9]
.L54:
	ldr	r3, [fp, #-8]
	cmp	r3, #1
	bgt	.L55
	ldrb	r3, [fp, #-9]
	lsl	r3, r3, #1
	strb	r3, [fp, #-9]
.L55:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L53:
	ldr	r3, [fp, #-8]
	cmp	r3, #2
	ble	.L56
	mov	r3, #3
	str	r3, [fp, #-8]
	b	.L57
.L60:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #49
	bne	.L58
	ldrb	r3, [fp, #-10]
	orr	r3, r3, #1
	strb	r3, [fp, #-10]
.L58:
	ldr	r3, [fp, #-8]
	cmp	r3, #9
	bgt	.L59
	ldrb	r3, [fp, #-10]
	lsl	r3, r3, #1
	strb	r3, [fp, #-10]
.L59:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L57:
	ldr	r3, [fp, #-8]
	cmp	r3, #10
	ble	.L60
	ldr	r2, .L86
	ldr	r3, [fp, #-20]
	add	r3, r2, r3
	ldrb	r2, [fp, #-10]
	strb	r2, [r3]
	ldr	r3, [fp, #-20]
	add	r3, r3, #1
	ldr	r1, .L86
	ldrb	r2, [fp, #-9]
	strb	r2, [r1, r3]
	ldr	r2, .L86+4
	ldr	r3, [fp, #-20]
	add	r3, r2, r3
	ldrb	r2, [fp, #-10]
	strb	r2, [r3]
	ldr	r3, [fp, #-20]
	add	r3, r3, #1
	ldr	r1, .L86+4
	ldrb	r2, [fp, #-9]
	strb	r2, [r1, r3]
	mov	r3, #0
	strb	r3, [fp, #-9]
	ldrb	r3, [fp, #-9]
	strb	r3, [fp, #-10]
	mov	r3, #12
	str	r3, [fp, #-8]
	b	.L61
.L64:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #49
	bne	.L62
	ldrb	r3, [fp, #-9]
	orr	r3, r3, #1
	strb	r3, [fp, #-9]
.L62:
	ldr	r3, [fp, #-8]
	cmp	r3, #17
	bgt	.L63
	ldrb	r3, [fp, #-9]
	lsl	r3, r3, #1
	strb	r3, [fp, #-9]
.L63:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L61:
	ldr	r3, [fp, #-8]
	cmp	r3, #18
	ble	.L64
	mov	r3, #19
	str	r3, [fp, #-8]
	b	.L65
.L68:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #49
	bne	.L66
	ldrb	r3, [fp, #-10]
	orr	r3, r3, #1
	strb	r3, [fp, #-10]
.L66:
	ldr	r3, [fp, #-8]
	cmp	r3, #25
	bgt	.L67
	ldrb	r3, [fp, #-10]
	lsl	r3, r3, #1
	strb	r3, [fp, #-10]
.L67:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L65:
	ldr	r3, [fp, #-8]
	cmp	r3, #26
	ble	.L68
	ldr	r3, [fp, #-20]
	add	r3, r3, #100
	ldr	r1, .L86
	ldrb	r2, [fp, #-10]
	strb	r2, [r1, r3]
	ldr	r3, [fp, #-20]
	add	r3, r3, #101
	ldr	r1, .L86
	ldrb	r2, [fp, #-9]
	strb	r2, [r1, r3]
	mov	r3, #0
	strb	r3, [fp, #-9]
	ldrb	r3, [fp, #-9]
	strb	r3, [fp, #-10]
	mov	r3, #28
	str	r3, [fp, #-8]
	b	.L69
.L72:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #49
	bne	.L70
	ldrb	r3, [fp, #-9]
	orr	r3, r3, #1
	strb	r3, [fp, #-9]
.L70:
	ldr	r3, [fp, #-8]
	cmp	r3, #33
	bgt	.L71
	ldrb	r3, [fp, #-9]
	lsl	r3, r3, #1
	strb	r3, [fp, #-9]
.L71:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L69:
	ldr	r3, [fp, #-8]
	cmp	r3, #34
	ble	.L72
	mov	r3, #35
	str	r3, [fp, #-8]
	b	.L73
.L76:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #49
	bne	.L74
	ldrb	r3, [fp, #-10]
	orr	r3, r3, #1
	strb	r3, [fp, #-10]
.L74:
	ldr	r3, [fp, #-8]
	cmp	r3, #41
	bgt	.L75
	ldrb	r3, [fp, #-10]
	lsl	r3, r3, #1
	strb	r3, [fp, #-10]
.L75:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L73:
	ldr	r3, [fp, #-8]
	cmp	r3, #42
	ble	.L76
	ldr	r2, .L86+8
	ldr	r3, [fp, #-20]
	add	r3, r2, r3
	ldrb	r2, [fp, #-10]
	strb	r2, [r3]
	ldr	r3, [fp, #-20]
	add	r3, r3, #1
	ldr	r1, .L86+8
	ldrb	r2, [fp, #-9]
	strb	r2, [r1, r3]
	mov	r3, #0
	strb	r3, [fp, #-9]
	ldrb	r3, [fp, #-9]
	strb	r3, [fp, #-10]
	mov	r3, #44
	str	r3, [fp, #-8]
	b	.L77
.L80:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #49
	bne	.L78
	ldrb	r3, [fp, #-9]
	orr	r3, r3, #1
	strb	r3, [fp, #-9]
.L78:
	ldr	r3, [fp, #-8]
	cmp	r3, #45
	bgt	.L79
	ldrb	r3, [fp, #-9]
	lsl	r3, r3, #1
	strb	r3, [fp, #-9]
.L79:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L77:
	ldr	r3, [fp, #-8]
	cmp	r3, #46
	ble	.L80
	mov	r3, #47
	str	r3, [fp, #-8]
	b	.L81
.L84:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #49
	bne	.L82
	ldrb	r3, [fp, #-10]
	orr	r3, r3, #1
	strb	r3, [fp, #-10]
.L82:
	ldr	r3, [fp, #-8]
	cmp	r3, #53
	bgt	.L83
	ldrb	r3, [fp, #-10]
	lsl	r3, r3, #1
	strb	r3, [fp, #-10]
.L83:
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L81:
	ldr	r3, [fp, #-8]
	cmp	r3, #54
	ble	.L84
	ldr	r3, [fp, #-20]
	add	r3, r3, #200
	ldr	r1, .L86
	ldrb	r2, [fp, #-10]
	strb	r2, [r1, r3]
	ldr	r3, [fp, #-20]
	add	r3, r3, #201
	ldr	r1, .L86
	ldrb	r2, [fp, #-9]
	strb	r2, [r1, r3]
	ldr	r3, [fp, #-8]
	mov	r0, r3
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
.L87:
	.align	2
.L86:
	.word	tb_mem
	.word	mem
	.word	corr
	.size	bits_to_buf, .-bits_to_buf
	.ident	"GCC: (Raspbian 6.3.0-18+rpi1+deb9u1) 6.3.0 20170516"
	.section	.note.GNU-stack,"",%progbits
