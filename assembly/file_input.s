//Filipe Marinho - create and write in a file, filename and description via user input sys_read
//made for: Linux debian 4.9.0-12-arm64  SMP Debian 4.9.210-1 (2020-01-20) aarch64 GNU/Linux
//run with as file_input.s -o file.o && ld file.o -o file &&./file

.equ BUFFERSIZE,   80
.equ TAILLEBUF,  1000
.equ AT_FDCWD,    -100
.equ O_RDWR,   0x0002
.equ O_CREAT,  0x040
.equ O_RDWR,   0x0002


/* Initialized data                        */
.data
szMessDeb: .asciz "Enter file name : "
szMessNum: .asciz "Enter the file text: "
szCarriageReturn:  .asciz "\n"

/* UnInitialized data                      */

.bss
sBuffer:    .skip    BUFFERSIZE
sBuffer1:    .skip    BUFFERSIZE

/*  code section                           */

.text
.global _start
_start:                      // entry of program

    //initial message
    ldr x0,qAdrszMessDeb
    bl affichageMess
    mov x0,0           // Linux input console stdin = 0
    ldr x1,qAdrsBuffer     // buffer address 
    mov x2,BUFFERSIZE      // buffer size 
    mov x8,63            // request to read datas read = 63
    svc 0                  // call system
    
    ldr x1,qAdrsBuffer     // buffer address 
    mov x2,#0              // end of string
    sub x0,x0,#1 	  // x0 contains the len, x0-1 will insert the byte at the last digit
    strb w2,[x1,x0]        // store byte at the end of input string (x0 contains number of characters)
 
    ldr x0,qAdrsBuffer     // buffer address 
    bl affichageMess
    ldr x0,qAdrszCarriageReturn   
    bl affichageMess
    
    
    //second message 
    ldr x0,qAdrszMessNum
    bl affichageMess
    mov x0,0           // Linux input console stdin = 0
    ldr x1,qAdrsBuffer1     // buffer address 
    mov x2,BUFFERSIZE      // buffer size 
    mov x8,63            // request to read datas read = 63
    svc 0                  // call system
    ldr x1,qAdrsBuffer1     // buffer address 
    mov x2,#0              // end of string
    strb w2,[x1,x0]        // store byte at the end of input string (x0
    
    mov x20,x0
    
    ldr x0,qAdrsBuffer1     // buffer address 
    bl affichageMess
    ldr x0,qAdrszCarriageReturn   
    bl affichageMess







	//create file and open
    mov x0,AT_FDCWD
    ldr x1,qAdrsBuffer  // file name
    mov x2,O_CREAT|O_RDWR        //  flag
    ldr x3,qFicMask1             // Mode
    mov x8,56                  // call system_open = 56 file
    svc 0
    mov x19,x0                   //save file descriptor

    //write to file
    ldr x1,qAdrsBuffer1
    mov x2,x20                   // length to write 
    mov x8, #64               // select system call 'write'
    svc #0                       // perform the system call

    //Close file
    mov x0,x19                   // Fd  fichier 
    mov x8, #57               //  call system CLOSE
    svc #0
 
100:   /* standard end of the program */
    mov x0, #0             // return code
    mov x8, #93          // request to exit program
    svc 0                  // perform the system call

affichageMess:
    stp x0,x1,[sp,-16]!        // save  registers
    stp x2,x8,[sp,-16]!        // save  registers
    mov x2,0                   // size counter 
1:                             // loop start
    ldrb w1,[x0,x2]            // load a byte
    cbz w1,2f                  // if zero -> end string
    add x2,x2,#1               // else increment counter
    b 1b                       // and loop
2:                             // x2 =  string size

    mov x1,x0                  // string address
    mov x0,1              // output Linux standard STDOUT=1
    mov x8,64               // code call system "write"=64
    svc 0                      // call systeme Linux
    ldp x2,x8,[sp],16          // restaur  2 registres
    ldp x0,x1,[sp],16          // restaur  2 registres
    ret                        // retour adresse lr x30


.align 4                   // instruction to realign the following routines
qAdrszMessDeb:        .quad szMessDeb
qAdrszMessNum:        .quad  szMessNum
qAdrsBuffer:          .quad  sBuffer
qAdrsBuffer1:          .quad  sBuffer1
qAdrszCarriageReturn: .quad  szCarriageReturn
qFicMask1:              .quad 0644
