# file_management.s

used this as [guide](https://www.tutorialspoint.com/assembly_programming/assembly_file_management.htm) but its made for i386, so used the syscall.txt to find the proper syscalls numbers.


[this](https://developer.ibm.com/technologies/linux/articles/l-gas-nasm/) may help


the lazy way to remove \n at the end of a input 
``` 
    ldr x0,qAdrszMessDeb
    bl affichageMess
    mov x0,0           // Linux input console STDIN=0
    ldr x1,qAdrsBuffer     // buffer address 
    mov x2,BUFFERSIZE      // buffer size 
    mov x8,63            // request to read datas, syscall read 63
    svc 0                  // call system
    ldr x1,qAdrsBuffer     // buffer address 
    mov x2,#0              // backspace
    sub x0,x0,#1           // x0 contains the len, x0-1 will insert the byte at the las digit
    strb w2,[x1,x0]        // store byte at the end of input string (x0 contains number of characters)
``
