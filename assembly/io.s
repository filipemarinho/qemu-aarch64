//Filipe Marinho - basic prompt, respond yes or no
//made for: Linux debian 4.9.0-12-arm64  SMP Debian 4.9.210-1 (2020-01-20) aarch64 GNU/Linux
//run with as io.s -o io.o && ld io.o -o io &&./io

.data
	buffer:		.zero 4			// fills n (4) bytes w/ zeros 
	prompt:         .asciz  "Sim ou não? (Enter S/s or N): \n"
	.equ            len.prompt,.-prompt

        yes: .asciz  " Sim!\n"
        .equ            len.yes,.-yes

        no: .asciz  " No!\n"
        .equ            len.no,.-no

	.align
.text
        .global _start

        .macro push2, xreg1, xreg2		// macro to save registers
        .push2\@:
         stp     \xreg1, \xreg2, [sp, #-16]!
        .endm

        .macro  pop2, xreg1, xreg2		//macro to restaur registers
        .pop2\@:
        ldp     \xreg1, \xreg2, [sp], #16
        .endm

        .align


_start:
        bl write_prompt
        .read_buffer:                   // label 
        bl read_buffer
        ldr x9,=buffer			//x9 recebe a leitura
        ldrb w11, [x9,x10]  // load one byte from buffer array at element n
        cmp w11, #0x53
        beq yes_exit        // if is equal to ASCII value for s, print yes and leave

        cmp w11, #0x73
        beq yes_exit        // if is equal to ASCII value for S, print yes and leave

	bl print_no
	bl exit

exit:
        mov x8, #93		// request to exit program
        mov x0, xzr		// return code	
        svc 0			// perform the system call

write_prompt:
        push2 x29, x30		// macro to save registers
        mov x8, #64              // request system write to file, sys_write = 64
        mov x0, #1              // output Linux standard STDOUT=1
        ldr x1,=prompt		// load message to write
        mov x2, #len.prompt	// length to write
        svc #0			// perform the system call
        pop2 x29, x30		//macro to restaur registers
        ret			// return


read_buffer:
        push2 x29, x30		// macro to save registers
        mov x8, #63             // request to read datas sys_read = 63
        mov x0, #0              // input Linux standard STDIN=0
        ldr x1,=buffer		// load message to write
        mov x2, #1              // arbitrary length
        svc #0			// perform the system call
        pop2 x29, x30		//macro to restaur registers
        ret			// return

yes_exit:
        push2 x29, x30		// macro to save registers
        mov x8, #64             // request system write to file, sys_write = 64
        mov x0, #1              // output Linux standard STDOUT=1
        ldr x1,=yes		// load message to write
        mov x2, #len.yes	// length to write
        svc #0			// perform the system call
        pop2 x29, x30		//macro to restaur registers
	bl exit			//exit routine
	ret			// return
print_no:
        push2 x29, x30		//save registers
        mov x8, #64             // request system write to file, sys_write = 64
        mov x0, #1              // output Linux standard STDOUT=1
        ldr x1,=no		// load message to write
        mov x2, #len.no		// length to write
        svc #0			// perform the system call
        pop2 x29, x30		//macro to restaur registers
        ret			// return




