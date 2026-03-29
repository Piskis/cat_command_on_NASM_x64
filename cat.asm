; ====== data and variables ====== ;

section .data
error_msg db "No sush file!",10,0
len equ $ - error_msg

section .bss
fd resq 1
buffer resb 256

; ====== code of program ====== ;

section .text
global _start
_start:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            ; If there is no
  mov rbx, [rsp]            ; arguments go to   
  cmp rbx, 2                ; no_args part
  jl _no_args               ; And set r14 as
  mov r14, 1                ; counter of args
                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            ; Compare r14 to quantity
_point:                     ; arguments and if 
  cmp r14, [rsp]            ; its ecual or greater
  jge _finish               ; go to finish
                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
                            ; Load effective adress of
  lea rbx, [rsp+8]          ; rsp+8 to rbx
                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            ; Open read-only file that
  mov rax, 2                ; is in the argument we are  
  mov rdi, [rbx+r14*8]      ; currently considering
  mov rsi, 0                ; 
  mov rdx, 0o644            ;
  syscall                   ;
                            ;
  cmp rax, 0                ; If file does not exists
  jl _fatal_error           ; go to fatal error part
  mov [rel fd], rax         ; 
                            ; Save file descriptot (fd)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            ; Read first 256 bytes of file 
_Read_Loop:                 ; and move it to buffer
  mov rax, 0                ;
  mov rdi, [rel fd]         ;
  mov rsi, buffer           ;
  mov rdx, 256              ;
  syscall                   ;
                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            ; Save on rbx the actual number 
  mov rbx, rax              ; of bytes of information read 
                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            ; Print what is in buffer
  mov rax, 1                ;
  mov rdi, 1                ;
  mov rsi, buffer           ;
  mov rdx, rbx              ;
  syscall                   ;
                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            ;
  cmp rbx, 0                ; If the buffer is empty then
  je .done                  ; go to .done part              
  jmp _Read_Loop            ; If not go to _Read_Loop part  
                            ;                               
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                               

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            ; add r14 1, then close current
.done:                      ; file using file descriptor (fd)
  inc r14                   ; 
  mov rax, 3                ; 
  mov rdi, [rel fd]         ;
  syscall                   ;
  jmp _point                ; go to _point 
                            ; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            ; 
_finish:                    ; 
  mov rax, 60               ; Exit program with code 0
  xor rdi, rdi              ;
  syscall                   ; 
                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            ; Print "No such file!"
_fatal_error:               ; and exit with code 1
  mov rax, 1                ;
  mov rdi, 1                ;
  mov rsi, error_msg        ;
  mov rdx, len              ;
  syscall                   ;
                            ;
  mov rax, 60               ;
  mov rdi, 1                ;
  syscall                   ;
                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                            ; If there is no arguments 
_no_args:                   ; then is nothing to do
  mov rax, 60               ; exit with code 1
  mov rdi, 1                ;
  syscall                   ;
                            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
