.data
//file_name db 'myfile.txt'
//msg db 'Welcome to Tutorials Point'
//len equ  $-msg

//msg_done db 'Written to file', 0xa
//len_done equ $-msg_done

file_name: .asciz  "myfile.txt"
.equ            len.file_name,.-file_name

msg: .asciz  "Hello World!"
.equ            len.msg,.-msg

msg_done: .asciz  "Written to file"
.equ            len.msg_done,.-msg_done

.bss
fd_out resb 1
fd_in  resb 1
info resb  26
//fd_out:        #1
//fd_in:         #1
//info:         #26
.align


.text
   .global _start         //must be declared for using gcc

_start:                  //tell linker entry point
   //create the file
   mov  x8, 1064		//system call number (sys_create)
   mov  x0, file_name
   mov  x1, 0777        //read, write and execute by all
   svc #0             //call kernel
	
   mov [fd_out], x8
    
   // write into the file
   mov	x2,len          //number of bytes
   mov	x1, msg         //message to write
   mov	x0, [fd_out]    //file descriptor 
   mov	x8,64            //system call number (sys_write)
   svc #0             //call kernel
	
   // close the file
   mov x8, 6
   mov x0, [fd_out]
    
   // write the message indicating end of file write
   mov x8, 4
   mov x0, 1
   mov x1, msg_done
   mov x2, len_done
   svc #0
    
   //open the file for reading
   mov x8, 1024		//system call number (sys_open)
   mov x0, file_name
   mov x1, 0             //for read only access
   mov x2, 0777          //read, write and execute by all
   svc #0
	
   mov  [fd_in], x8
    
   //read from file
   mov x8, 63		//system call number (sys_read)
   mov x0, [fd_in]
   mov x1, info
   mov x2, 26
   svc #0
    
   // close the file
   mov x8, 57		//system call number (sys_close)
   mov x0, [fd_in]
   svc #0    
	
   // print the info 
   mov x8, 64		//system call number (sys_write)
   mov x0, 1
   mov x1, info
   mov x2, 26
   svc #0
       
   mov	x8,93             //system call number (sys_exit)
   svc #0              //call kernel
