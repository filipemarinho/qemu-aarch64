.bss
	buffer:         .zero 4                 // fill n bytes w/ zeros
	.align
.data
	prompt:         .asciz  "Tu eh neh? (S or N): \n"
	.equ            len.prompt,.-prompt

        yes: .asciz  " Sim!\n"
        .equ            len.yes,.-yes

        no: .asciz  " No!\n"
        .equ            len.no,.-no

	.align
.text
        .global _start

        .macro push2, xreg1, xreg2
        .push2\@:
         stp     \xreg1, \xreg2, [sp, #-16]!
        .endm

        .macro  pop2, xreg1, xreg2
        .pop2\@:
        ldp     \xreg1, \xreg2, [sp], #16
        .endm

        .align


_start:
        nop
        bl write_prompt
        .read_buffer:                   // label for looping when input values are not between ASCII 0 and 9
        bl read_buffer
        ldr x9,=buffer			//x9 recebe a leitura
        //mov x10, xzr                    // counter
        //1:
        ldrb w11, [x9,x10]      // load one byte from buffer array at element n
        cmp w11, #0x53
        beq yes_exit        // if is equal to ASCII value for s, print yes and leave

        cmp w11, #0x73
        beq yes_exit        // if is equal to ASCII value for S, print yes and leave

	bl print_no
	bl exit

exit:
        mov x8, #93
        mov x0, xzr
        svc 0

write_prompt:
        push2 x29, x30
        mov x8, #64              // syscall write
        mov x0, #1              // fd dtdout
        ldr x1,=prompt
        mov x2, #len.prompt
        svc #0
        pop2 x29, x30
        ret


read_buffer:
        push2 x29, x30
        mov x8, #63              // syscall read
        mov x0, #0              // fd stdin
        ldr x1,=buffer
        mov x2, #1              // arbitrary length
        svc #0
        pop2 x29, x30
        ret

yes_exit:
        push2 x29, x30
        mov x8, #64              // syscall write
        mov x0, #1              // fd stdout
        ldr x1,=yes
        mov x2, #len.yes
        svc #0
        pop2 x29, x30
	bl exit
	ret
print_no:
        push2 x29, x30
        mov x8, #64              // syscall write
        mov x0, #1              // fd stdout
        ldr x1,=no
        mov x2, #len.no
        svc #0
        pop2 x29, x30
        ret

write_result:
        push2 x29, x30
        mov x8, #64              // syscall write
        mov x0, #1              // fd stdout
        ldr x1,=yes
        mov x2, #len.yes
        svc #0
        pop2 x29, x30
        ret


flush:
        push2 x29, x30
        mov x8, #63              // syscall read
        mov x0, #2              // fd stderr
        ldr x1,=buffer
        mov x2, #(1 << 30)      // experiment with this
        svc #0
        pop2 x29, x30
        ret
