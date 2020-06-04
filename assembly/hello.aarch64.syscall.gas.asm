/*
Tested: Linux debian 4.9.0-12-arm64 #1 SMP Debian 4.9.210-1 (2020-01-20) aarch64 GNU/Linux
First program: Output "Hello world!". 

as -o hello.o hello.aarch64.syscall.gas.asm && ld -o hello hello.o
*/

.globl _start
.section .text

_start:

	mov x8, #64
	mov x0, #1
	adrp x1, message
	add x1, x1, :lo12:message
	mov x2, 13
	svc #0

	mov x8, #93
	mov x0, #42
	svc #0

	ret

.section .rodata
message:
	.asciz "Hello world !!!!\n"
