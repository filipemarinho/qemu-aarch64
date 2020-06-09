//Filipe Marinho - copy a input.txt file (must be created) to a new file output.txt
//made for: Linux debian 4.9.0-12-arm64  SMP Debian 4.9.210-1 (2020-01-20) aarch64 GNU/Linux
//run with as copy_file.s -o file.o && ld file.o -o file &&./file
 
.equ TAILLEBUF,  1000
.equ AT_FDCWD,    -100
.equ O_RDWR,   0x0002
.equ O_CREAT,  0x040
.equ O_RDWR,   0x0002

/* Initialized data              */

.data
szMessErreur:  .asciz "Error open input file.\n"
szMessErreur4: .asciz "Error open output file.\n"
szMessErreur1: .asciz "Error close file.\n"
szMessErreur2: .asciz "Error read file.\n"
szMessErreur3: .asciz "Error write output file.\n"
 
/*************************************************/
szMessCodeErr: .asciz "Error code decimal :   \n"
 
szNameFileInput:     .asciz "input.txt"
szNameFileOutput:    .asciz "output.txt"

/* UnInitialized data                      */
 
.bss
sBuffer:        .skip TAILLEBUF 
sZoneConv:      .skip 24

/* -- Code section                            */

.text
.global _start
_start:                            // entry of program 
    mov x0,AT_FDCWD
    ldr x1,qAdrszNameFileInput   // file name
    mov x2,#O_RDWR               //  flags   
    mov x3,#0                    // mode 
    mov x8,#56                 // call system OPEN
    svc #0 
    cmp x0,0                     // open error ?
    ble erreur
    mov x19,x0                   // save File Descriptor
    ldr x1,qAdrsBuffer           // buffer address 
    mov x2,TAILLEBUF             // buffer size
    mov x8,63                  // call system  READ
    svc 0 
    cmp x0,0                     // read error ?
    ble erreur2
    mov x20,x0                    // length read characters
                                 // close imput file
    mov x0,x19                   // Fd  
    mov x8,57                 // call system CLOSE
    svc 0 
    cmp x0,0                     // close error ?
    blt erreur1
 
                                 // create output file
    mov x0,AT_FDCWD
    ldr x1,qAdrszNameFileOutput  // file name
    mov x2,O_CREAT|O_RDWR        //  flags   
    ldr x3,qFicMask1             // Mode
    mov x8,56                  // call system open file
    svc 0 
    cmp x0,#0                    // create error ?
    ble erreur4
    mov x19,x0                   // file descriptor
    ldr x1,qAdrsBuffer
    mov x2,x20                   // length to write 
    mov x8, #64               // select system call 'write'
    svc #0                       // perform the system call 
    cmp x0,#0                    // error write ?
    blt erreur3
 
                                 // close output file 
    mov x0,x19                   // Fd  fichier 
    mov x8, #57               //  call system CLOSE
    svc #0 
    cmp x0,#0                    // error close ?
    blt erreur1
    mov x0,#0                    // return code OK
    b 100f
erreur:
    ldr x1,qAdrszMessErreur 
    bl  displayError
    mov x0,#1                   // error return code
    b 100f
erreur1:    
    ldr x1,qAdrszMessErreur1   
    bl  displayError
    mov x0,#1                   // error return code
    b 100f
erreur2:
    ldr x1,qAdrszMessErreur2   
    bl  displayError
    mov x0,#1                  // error return code
    b 100f
erreur3:
    ldr x1,qAdrszMessErreur
    bl  displayError
    mov x0,#1                 // error return code
    b 100f
erreur4:
    ldr x1,qAdrszMessErreur4
    bl  displayError
    mov x0,#1                 // error return code
    b 100f
 
100:                          // end program
    mov x8,93
    svc 0 

affichageMess:
    stp x0,x1,[sp,-16]!        // save  registers
    stp x2,x8,[sp,-16]!        // save  registers
    mov x2,0                   // size counter

conversion10S:
    stp x5,x30,[sp,-16]!        // save  registers
    stp x3,x4,[sp,-16]!        // save  registers
    stp x1,x2,[sp,-16]!        // save  registers
    cmp x0,0                   // is negative ?
    bge 11f                    // no 
    mov x3,'-'                 // yes
    neg x0,x0                  // number inversion 
    b 12f
11:
    mov x3,'+'                 // positive number
12:
    strb w3,[x1]
    mov x4,#21         // position last digit
    mov x5,#10                 // decimal conversion 
strInsertAtCharInc:
    stp x2,x30,[sp,-16]!                      // save  registers
    stp x3,x4,[sp,-16]!                      // save  registers
    stp x5,x6,[sp,-16]!                      // save  registers
    stp x7,x8,[sp,-16]!                      // save  registers
    mov x3,#0                                // length counter 


qAdrszNameFileInput:    .quad szNameFileInput
qAdrszNameFileOutput:   .quad szNameFileOutput
qAdrszMessErreur:       .quad szMessErreur
qAdrszMessErreur1:      .quad szMessErreur1
qAdrszMessErreur2:      .quad szMessErreur2
qAdrszMessErreur3:      .quad szMessErreur3
qAdrszMessErreur4:      .quad szMessErreur4
qAdrsBuffer:            .quad sBuffer
qFicMask1:              .quad 0644

/*     display error message                                      */ 

/* x0 contains error code */
/* x1 contains address error message    */
displayError:
    stp x2,x30,[sp,-16]!            // save  registers
    mov x2,x0                      // save error code
    mov x0,x1                      // display message error
    bl affichageMess
    mov x0,x2
    ldr x1,qAdrsZoneConv           // conversion error code
    bl conversion10S               // decimal conversion
    ldr x0,qAdrszMessCodeErr
    ldr x1,qAdrsZoneConv
    bl strInsertAtCharInc          // insert result at @ character
    bl affichageMess               // display message final
    ldp x2,x30,[sp],16              // restaur  2 registers
    ret                            // return to address lr x30
qAdrsZoneConv:        .quad sZoneConv
qAdrszMessCodeErr:    .quad szMessCodeErr


//from: https://www.rosettacode.org/wiki/File_input/output
//and: https://www.rosettacode.org/wiki/Include_a_file
