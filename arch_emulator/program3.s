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
	.file	"program3.c"
	.section	.rodata
	.align	2
.LC0:
	.ascii	"\012************************RESULTS****************"
	.ascii	"**********\000"
	.align	2
.LC1:
	.ascii	"bit_str1\011%d\011%d\011%d\012\000"
	.align	2
.LC2:
	.ascii	"bit_str2\011%d\011%d\011%d\012\000"
	.align	2
.LC3:
	.ascii	"bit_str3\011%d\011%d\011%d\012\000"
	.align	2
.LC4:
	.ascii	"bit_str4\011%d\011%d\011%d\012\000"
	.align	2
.LC5:
	.ascii	"bit_str5\011%d\011%d\011%d\012\000"
	.text
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu vfp
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 48
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r5, fp, lr}
	add	fp, sp, #12
	sub	sp, sp, #56
	mov	r3, #11
	strb	r3, [fp, #-13]
	sub	ip, fp, #48
	sub	r2, fp, #40
	sub	r1, fp, #32
	sub	r0, fp, #24
	sub	r3, fp, #56
	str	r3, [sp]
	mov	r3, ip
	bl	init_bitstr
	ldr	r0, .L3
	bl	puts
	sub	r2, fp, #24
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_bytes
	mov	r4, r0
	sub	r2, fp, #24
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_occur
	mov	r5, r0
	sub	r2, fp, #24
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_occur2
	mov	r3, r0
	mov	r2, r5
	mov	r1, r4
	ldr	r0, .L3+4
	bl	printf
	sub	r2, fp, #32
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_bytes
	mov	r4, r0
	sub	r2, fp, #32
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_occur
	mov	r5, r0
	sub	r2, fp, #32
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_occur2
	mov	r3, r0
	mov	r2, r5
	mov	r1, r4
	ldr	r0, .L3+8
	bl	printf
	sub	r2, fp, #40
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_bytes
	mov	r4, r0
	sub	r2, fp, #40
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_occur
	mov	r5, r0
	sub	r2, fp, #40
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_occur2
	mov	r3, r0
	mov	r2, r5
	mov	r1, r4
	ldr	r0, .L3+12
	bl	printf
	sub	r2, fp, #48
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_bytes
	mov	r4, r0
	sub	r2, fp, #48
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_occur
	mov	r5, r0
	sub	r2, fp, #48
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_occur2
	mov	r3, r0
	mov	r2, r5
	mov	r1, r4
	ldr	r0, .L3+16
	bl	printf
	sub	r2, fp, #56
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_bytes
	mov	r4, r0
	sub	r2, fp, #56
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_occur
	mov	r5, r0
	sub	r2, fp, #56
	ldrb	r3, [fp, #-13]	@ zero_extendqisi2
	mov	r1, r2
	mov	r0, r3
	bl	cnt_occur2
	mov	r3, r0
	mov	r2, r5
	mov	r1, r4
	ldr	r0, .L3+20
	bl	printf
	ldr	r0, .L3
	bl	puts
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #12
	@ sp needed
	pop	{r4, r5, fp, pc}
.L4:
	.align	2
.L3:
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.word	.LC3
	.word	.LC4
	.word	.LC5
	.size	main, .-main
	.align	2
	.global	cnt_bytes
	.syntax unified
	.arm
	.fpu vfp
	.type	cnt_bytes, %function
cnt_bytes:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #28
	mov	r3, r0
	str	r1, [fp, #-28]
	strb	r3, [fp, #-21]
	mov	r3, #0
	str	r3, [fp, #-16]
	mov	r3, #7
	str	r3, [fp, #-8]
	b	.L6
.L10:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-28]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-17]
	mov	r3, #0
	str	r3, [fp, #-12]
	b	.L7
.L9:
	ldrb	r2, [fp, #-17]
	ldrb	r3, [fp, #-21]
	eor	r3, r3, r2
	strb	r3, [fp, #-18]
	ldrb	r3, [fp, #-18]
	lsl	r3, r3, #4
	strb	r3, [fp, #-18]
	ldrb	r3, [fp, #-18]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L8
	ldr	r3, [fp, #-16]
	add	r3, r3, #1
	str	r3, [fp, #-16]
.L8:
	ldrb	r3, [fp, #-17]	@ zero_extendqisi2
	lsr	r3, r3, #1
	strb	r3, [fp, #-17]
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]
.L7:
	ldr	r3, [fp, #-12]
	cmp	r3, #4
	ble	.L9
	ldr	r3, [fp, #-8]
	sub	r3, r3, #1
	str	r3, [fp, #-8]
.L6:
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	bge	.L10
	ldr	r3, [fp, #-16]
	mov	r0, r3
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
	.size	cnt_bytes, .-cnt_bytes
	.align	2
	.global	cnt_occur
	.syntax unified
	.arm
	.fpu vfp
	.type	cnt_occur, %function
cnt_occur:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #28
	mov	r3, r0
	str	r1, [fp, #-28]
	strb	r3, [fp, #-21]
	mov	r3, #0
	str	r3, [fp, #-16]
	ldrb	r3, [fp, #-21]
	lsl	r3, r3, #4
	strb	r3, [fp, #-21]
	ldr	r3, [fp, #-28]
	ldrb	r3, [r3, #7]
	strb	r3, [fp, #-17]
	mov	r3, #0
	str	r3, [fp, #-12]
	b	.L13
.L16:
	ldrb	r2, [fp, #-17]
	ldrb	r3, [fp, #-21]
	eor	r3, r3, r2
	strb	r3, [fp, #-18]
	ldrb	r3, [fp, #-18]	@ zero_extendqisi2
	lsr	r3, r3, #4
	strb	r3, [fp, #-18]
	ldrb	r3, [fp, #-18]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L14
	ldr	r3, [fp, #-16]
	add	r3, r3, #1
	str	r3, [fp, #-16]
.L14:
	ldr	r3, [fp, #-12]
	cmp	r3, #3
	bgt	.L15
	ldrb	r3, [fp, #-17]
	lsl	r3, r3, #1
	strb	r3, [fp, #-17]
.L15:
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]
.L13:
	ldr	r3, [fp, #-12]
	cmp	r3, #4
	ble	.L16
	mov	r3, #6
	str	r3, [fp, #-8]
	b	.L17
.L26:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-28]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	lsr	r3, r3, #4
	uxtb	r2, r3
	ldrb	r3, [fp, #-17]
	orr	r3, r2, r3
	strb	r3, [fp, #-17]
	ldrb	r3, [fp, #-17]
	lsl	r3, r3, #1
	strb	r3, [fp, #-17]
	mov	r3, #0
	str	r3, [fp, #-12]
	b	.L18
.L21:
	ldrb	r2, [fp, #-17]
	ldrb	r3, [fp, #-21]
	eor	r3, r3, r2
	strb	r3, [fp, #-18]
	ldrb	r3, [fp, #-18]	@ zero_extendqisi2
	lsr	r3, r3, #4
	strb	r3, [fp, #-18]
	ldrb	r3, [fp, #-18]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L19
	ldr	r3, [fp, #-16]
	add	r3, r3, #1
	str	r3, [fp, #-16]
.L19:
	ldr	r3, [fp, #-12]
	cmp	r3, #2
	bgt	.L20
	ldrb	r3, [fp, #-17]
	lsl	r3, r3, #1
	strb	r3, [fp, #-17]
.L20:
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]
.L18:
	ldr	r3, [fp, #-12]
	cmp	r3, #3
	ble	.L21
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-28]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	sxtb	r3, r3
	and	r3, r3, #15
	sxtb	r2, r3
	ldrsb	r3, [fp, #-17]
	orr	r3, r2, r3
	sxtb	r3, r3
	strb	r3, [fp, #-17]
	ldrb	r3, [fp, #-17]
	lsl	r3, r3, #1
	strb	r3, [fp, #-17]
	mov	r3, #0
	str	r3, [fp, #-12]
	b	.L22
.L25:
	ldrb	r2, [fp, #-17]
	ldrb	r3, [fp, #-21]
	eor	r3, r3, r2
	strb	r3, [fp, #-18]
	ldrb	r3, [fp, #-18]	@ zero_extendqisi2
	lsr	r3, r3, #4
	strb	r3, [fp, #-18]
	ldrb	r3, [fp, #-18]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L23
	ldr	r3, [fp, #-16]
	add	r3, r3, #1
	str	r3, [fp, #-16]
.L23:
	ldr	r3, [fp, #-12]
	cmp	r3, #2
	bgt	.L24
	ldrb	r3, [fp, #-17]
	lsl	r3, r3, #1
	strb	r3, [fp, #-17]
.L24:
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]
.L22:
	ldr	r3, [fp, #-12]
	cmp	r3, #3
	ble	.L25
	ldr	r3, [fp, #-8]
	sub	r3, r3, #1
	str	r3, [fp, #-8]
.L17:
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	bge	.L26
	ldr	r3, [fp, #-16]
	mov	r0, r3
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
	.size	cnt_occur, .-cnt_occur
	.align	2
	.global	cnt_occur2
	.syntax unified
	.arm
	.fpu vfp
	.type	cnt_occur2, %function
cnt_occur2:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #36
	mov	r3, r0
	str	r1, [fp, #-36]
	strb	r3, [fp, #-29]
	mov	r3, #0
	str	r3, [fp, #-16]
	mov	r3, #7
	str	r3, [fp, #-8]
	b	.L29
.L34:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-36]
	add	r3, r2, r3
	ldrb	r3, [r3]
	strb	r3, [fp, #-17]
	mov	r3, #0
	str	r3, [fp, #-12]
	mov	r3, #0
	str	r3, [fp, #-24]
	b	.L30
.L33:
	ldrb	r2, [fp, #-17]
	ldrb	r3, [fp, #-29]
	eor	r3, r3, r2
	strb	r3, [fp, #-25]
	ldrb	r3, [fp, #-25]
	lsl	r3, r3, #4
	strb	r3, [fp, #-25]
	ldrb	r3, [fp, #-25]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L31
	ldr	r3, [fp, #-16]
	add	r3, r3, #1
	str	r3, [fp, #-16]
	mov	r3, #1
	str	r3, [fp, #-24]
.L31:
	ldrb	r3, [fp, #-17]	@ zero_extendqisi2
	lsr	r3, r3, #1
	strb	r3, [fp, #-17]
	ldr	r3, [fp, #-12]
	add	r3, r3, #1
	str	r3, [fp, #-12]
.L30:
	ldr	r3, [fp, #-24]
	cmp	r3, #0
	bne	.L32
	ldr	r3, [fp, #-12]
	cmp	r3, #4
	ble	.L33
.L32:
	ldr	r3, [fp, #-8]
	sub	r3, r3, #1
	str	r3, [fp, #-8]
.L29:
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	bge	.L34
	ldr	r3, [fp, #-16]
	mov	r0, r3
	add	sp, fp, #0
	@ sp needed
	ldr	fp, [sp], #4
	bx	lr
	.size	cnt_occur2, .-cnt_occur2
	.section	.rodata
	.align	2
.LC6:
	.ascii	"\012************************MESSAGES***************"
	.ascii	"***********\000"
	.align	2
.LC7:
	.ascii	"\012bit_str1\000"
	.align	2
.LC8:
	.ascii	"\011%.2X\000"
	.align	2
.LC9:
	.ascii	"\012bit_str2\000"
	.align	2
.LC10:
	.ascii	"\012bit_str3\000"
	.align	2
.LC11:
	.ascii	"\012bit_str4\000"
	.align	2
.LC12:
	.ascii	"\012bit_str5\000"
	.text
	.align	2
	.global	init_bitstr
	.syntax unified
	.arm
	.fpu vfp
	.type	init_bitstr, %function
init_bitstr:
	@ args = 4, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	str	r2, [fp, #-24]
	str	r3, [fp, #-28]
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L37
.L38:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-16]
	add	ip, r2, r3
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-20]
	add	r3, r2, r3
	ldr	r2, [fp, #-8]
	ldr	r1, [fp, #-24]
	add	r2, r1, r2
	ldr	r1, [fp, #-8]
	ldr	r0, [fp, #-28]
	add	r1, r0, r1
	ldr	r0, [fp, #-8]
	ldr	lr, [fp, #4]
	add	r0, lr, r0
	mov	lr, #0
	strb	lr, [r0]
	ldrb	r0, [r0]	@ zero_extendqisi2
	strb	r0, [r1]
	ldrb	r1, [r1]	@ zero_extendqisi2
	strb	r1, [r2]
	ldrb	r2, [r2]	@ zero_extendqisi2
	strb	r2, [r3]
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [ip]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
.L37:
	ldr	r3, [fp, #-8]
	cmp	r3, #7
	ble	.L38
	ldr	r3, [fp, #-20]
	add	r0, r3, #1
	ldr	r3, [fp, #-24]
	add	r3, r3, #1
	ldr	r2, [fp, #-28]
	add	r2, r2, #1
	ldr	r1, [fp, #4]
	add	r1, r1, #1
	mvn	ip, #79
	strb	ip, [r1]
	ldrb	r1, [r1]	@ zero_extendqisi2
	strb	r1, [r2]
	ldrb	r2, [r2]	@ zero_extendqisi2
	strb	r2, [r3]
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r0]
	ldr	r3, [fp, #-24]
	add	r1, r3, #2
	ldr	r3, [fp, #-28]
	add	r3, r3, #2
	ldr	r2, [fp, #4]
	add	r2, r2, #2
	mvn	r0, #68
	strb	r0, [r2]
	ldrb	r2, [r2]	@ zero_extendqisi2
	strb	r2, [r3]
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r1]
	ldr	r3, [fp, #-28]
	add	r2, r3, #4
	ldr	r3, [fp, #4]
	add	r3, r3, #4
	mvn	r1, #63
	strb	r1, [r3]
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r2]
	ldr	r3, [fp, #-28]
	add	r2, r3, #5
	ldr	r3, [fp, #4]
	add	r3, r3, #5
	mov	r1, #2
	strb	r1, [r3]
	ldrb	r3, [r3]	@ zero_extendqisi2
	strb	r3, [r2]
	ldr	r3, [fp, #4]
	add	r3, r3, #7
	mvn	r2, #68
	strb	r2, [r3]
	ldr	r0, .L49
	bl	printf
	ldr	r0, .L49+4
	bl	printf
	mov	r3, #7
	str	r3, [fp, #-8]
	b	.L39
.L40:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-16]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r1, r3
	ldr	r0, .L49+8
	bl	printf
	ldr	r3, [fp, #-8]
	sub	r3, r3, #1
	str	r3, [fp, #-8]
.L39:
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	bgt	.L40
	ldr	r0, .L49+12
	bl	printf
	mov	r3, #7
	str	r3, [fp, #-8]
	b	.L41
.L42:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-20]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r1, r3
	ldr	r0, .L49+8
	bl	printf
	ldr	r3, [fp, #-8]
	sub	r3, r3, #1
	str	r3, [fp, #-8]
.L41:
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	bgt	.L42
	ldr	r0, .L49+16
	bl	printf
	mov	r3, #7
	str	r3, [fp, #-8]
	b	.L43
.L44:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-24]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r1, r3
	ldr	r0, .L49+8
	bl	printf
	ldr	r3, [fp, #-8]
	sub	r3, r3, #1
	str	r3, [fp, #-8]
.L43:
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	bgt	.L44
	ldr	r0, .L49+20
	bl	printf
	mov	r3, #7
	str	r3, [fp, #-8]
	b	.L45
.L46:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #-28]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r1, r3
	ldr	r0, .L49+8
	bl	printf
	ldr	r3, [fp, #-8]
	sub	r3, r3, #1
	str	r3, [fp, #-8]
.L45:
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	bgt	.L46
	ldr	r0, .L49+24
	bl	printf
	mov	r3, #7
	str	r3, [fp, #-8]
	b	.L47
.L48:
	ldr	r3, [fp, #-8]
	ldr	r2, [fp, #4]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	mov	r1, r3
	ldr	r0, .L49+8
	bl	printf
	ldr	r3, [fp, #-8]
	sub	r3, r3, #1
	str	r3, [fp, #-8]
.L47:
	ldr	r3, [fp, #-8]
	cmp	r3, #0
	bgt	.L48
	ldr	r0, .L49
	bl	puts
	nop
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
.L50:
	.align	2
.L49:
	.word	.LC6
	.word	.LC7
	.word	.LC8
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.word	.LC12
	.size	init_bitstr, .-init_bitstr
	.ident	"GCC: (Raspbian 6.3.0-18+rpi1+deb9u1) 6.3.0 20170516"
	.section	.note.GNU-stack,"",%progbits
