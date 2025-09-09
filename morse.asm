%define EFI_SUCCESS                            0

%define OFFSET_EFI_SYSTEM_TABLE_ConIn          0x30
%define OFFSET_EFI_SYSTEM_TABLE_ConOut         0x40

%define OFFSET_STO_Reset                       0x00
%define OFFSET_STO_OutputString                0x08

%define OFFSET_SIN_Reset                       0x00
%define OFFSET_SIN_ReadKeyStroke               0x08

%define CHAR_BACKSPACE                         0x0008
%define CHAR_RETURN                            0x000D  
%define EFI_SCAN_ESC                           0x0017  

%define BUF_MAX                                512    

default rel
extern  __chkstk

section .text
align 16
global  efi_main

efi_main:
    sub     rsp, 32
    mov     rsi, rdx                              

    mov     rbx, [rsi + OFFSET_EFI_SYSTEM_TABLE_ConOut] 
    mov     rdi, [rsi + OFFSET_EFI_SYSTEM_TABLE_ConIn]  

    mov     rcx, rbx
    xor     rdx, rdx
    mov     r11, [rbx + OFFSET_STO_Reset]
    call    r11

    mov     rcx, rdi
    xor     rdx, rdx
    mov     r11, [rdi + OFFSET_SIN_Reset]
    call    r11

    mov     rcx, rbx
    lea     rdx, [rel inicio_str]
    mov     r11, [rbx + OFFSET_STO_OutputString]
    call    r11

    lea     r12, [rel line_buf]
    xor     r13, r13                                 

.prompt:

    mov     rcx, rbx
    lea     rdx, [rel prompt_str]
    mov     r11, [rbx + OFFSET_STO_OutputString]
    call    r11

.read_loop:

    mov     rcx, rdi
    lea     rdx, [rel key_buf]
    mov     r11, [rdi + OFFSET_SIN_ReadKeyStroke]
    call    r11
    test    rax, rax
    jnz     .read_loop

    movzx   eax, word [key_buf + 0]                 
    movzx   edx, word [key_buf + 2]                 

    cmp     ax, EFI_SCAN_ESC
    je      .exit


    cmp     dx, CHAR_RETURN
    je      .flush_line

    cmp     dx, CHAR_BACKSPACE
    je      .handle_bs

    test    dx, dx
    jz      .read_loop

    cmp     r13, BUF_MAX-1
    jae     .beep_or_ignore                         

    mov     [r12 + r13*2], dx
    inc     r13

    jmp     .read_loop

.handle_bs:
    test    r13, r13
    jz      .read_loop
    dec     r13
    jmp     .read_loop



.flush_line:

    mov     word [r12 + r13*2], 0

    xor     r14, r14               

.iter_loop:
    cmp     r14, r13
    jae     .after_iter     

    movzx   edx, word [r12 + r14*2] 
    inc     r14

    cmp     dx, 'a'
    je      .print_for_a
    cmp     dx, 'A'
    je      .print_for_a


    jmp     .iter_loop

.print_for_a:
    mov     rcx, rbx
    lea     rdx, [rel map_a]       
    mov     r11, [rbx + OFFSET_STO_OutputString]
    call    r11

    mov     rcx, rbx
    lea     rdx, [rel crlf_str]
    mov     r11, [rbx + OFFSET_STO_OutputString]
    call    r11
    jmp     .iter_loop


.after_iter:

    mov     rcx, rbx
    lea     rdx, [rel crlf_str]
    mov     r11, [rbx + OFFSET_STO_OutputString]
    call    r11

    xor     r13, r13
    jmp     .prompt


.beep_or_ignore:

    jmp     .read_loop

.exit:
    mov     rcx, rbx
    lea     rdx, [rel bye_str]
    mov     r11, [rbx + OFFSET_STO_OutputString]
    call    r11

    xor     rax, rax
    add     rsp, 32
    ret

section .data
align 2
inicio_str:     dw 'I','n','g','r','e','s','e',' ','p','a','l','a','b','r','a','s',':',13,10,0
map_a:  dw 'Detectada la letra A/a',0

prompt_str:   dw '>', ' ', 0
crlf_str:     dw 13,10,0
bye_str:      dw 13,10,'S','a','l','i','e','n','d','o',' ','c','o','n',' ','E','S','C','.',13,10,0

section .bss
align 2
key_buf:                
    resw 2
line_buf:               
    resw BUF_MAX

section .reloc
align 4
dd 0