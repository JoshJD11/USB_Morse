%define EFI_SUCCESS 0
%define OFFSET_EFI_SYSTEM_TABLE_ConIn 0x30
%define OFFSET_EFI_SYSTEM_TABLE_ConOut 0x40
%define OFFSET_STO_Reset 0x00
%define OFFSET_STO_OutputString 0x08
%define OFFSET_SIN_Reset 0x00
%define OFFSET_SIN_ReadKeyStroke 0x08
%define CHAR_BACKSPACE 0x0008
%define CHAR_RETURN 0x000D
%define EFI_SCAN_ESC 0x0017
%define BUF_MAX 512

%macro PRINT_STR 1
    mov rcx, rbx
    lea rdx, [rel %1]
    mov r11, [rbx + OFFSET_STO_OutputString]
    call r11
%endmacro

default rel
extern __chkstk

section .text
align 16
global efi_main

efi_main:
    sub rsp, 32
    mov rsi, rdx
    mov rbx, [rsi + OFFSET_EFI_SYSTEM_TABLE_ConOut]
    mov rdi, [rsi + OFFSET_EFI_SYSTEM_TABLE_ConIn]
    mov rcx, rbx
    xor rdx, rdx
    mov r11, [rbx + OFFSET_STO_Reset]
    call r11
    mov rcx, rdi
    xor rdx, rdx
    mov r11, [rdi + OFFSET_SIN_Reset]
    call r11
    PRINT_STR init_str
    lea r12, [rel line_buf]
    xor r13, r13

.prompt:
    PRINT_STR prompt_str

.read_loop:
    mov rcx, rdi
    lea rdx, [rel key_buf]
    mov r11, [rdi + OFFSET_SIN_ReadKeyStroke]
    call r11
    test rax, rax
    jnz .read_loop
    movzx eax, word [key_buf + 0]
    movzx edx, word [key_buf + 2]
    cmp ax, EFI_SCAN_ESC
    je .exit
    cmp dx, CHAR_RETURN
    je .flush_line
    cmp dx, CHAR_BACKSPACE
    je .handle_bs
    test dx, dx
    jz .read_loop
    cmp r13, BUF_MAX-1
    jae .beep_or_ignore
    mov [r12 + r13*2], dx
    inc r13
    jmp .read_loop

.handle_bs:
    test r13, r13
    jz .read_loop
    dec r13
    jmp .read_loop

.flush_line:
    mov word [r12 + r13*2], 0
    PRINT_STR line_buf
    PRINT_STR crlf_str
    xor r14, r14

.iter_loop:
    cmp r14, r13
    jae .after_iter
    movzx edx, word [r12 + r14*2]
    inc r14
    cmp dx, 'a'
    je .print_for_a
    cmp dx, 'A'
    je .print_for_a
    cmp dx, 'b'
    je .print_for_b
    cmp dx, 'B'
    je .print_for_b
    cmp dx, 'c'
    je .print_for_c
    cmp dx, 'C'
    je .print_for_c
    cmp dx, 'd'
    je .print_for_d
    cmp dx, 'D'
    je .print_for_d
    cmp dx, 'e'
    je .print_for_e
    cmp dx, 'E'
    je .print_for_e
    cmp dx, 'f'
    je .print_for_f
    cmp dx, 'F'
    je .print_for_f
    cmp dx, 'g'
    je .print_for_g
    cmp dx, 'G'
    je .print_for_g
    cmp dx, 'h'
    je .print_for_h
    cmp dx, 'H'
    je .print_for_h
    cmp dx, 'i'
    je .print_for_i
    cmp dx, 'I'
    je .print_for_i
    cmp dx, 'j'
    je .print_for_j
    cmp dx, 'J'
    je .print_for_j
    cmp dx, 'k'
    je .print_for_k
    cmp dx, 'K'
    je .print_for_k
    cmp dx, 'l'
    je .print_for_l
    cmp dx, 'L'
    je .print_for_l
    cmp dx, 'm'
    je .print_for_m
    cmp dx, 'M'
    je .print_for_m
    cmp dx, 'n'
    je .print_for_n
    cmp dx, 'N'
    je .print_for_n
    cmp dx, 'o'
    je .print_for_o
    cmp dx, 'O'
    je .print_for_o
    cmp dx, 'p'
    je .print_for_p
    cmp dx, 'P'
    je .print_for_p
    cmp dx, 'q'
    je .print_for_q
    cmp dx, 'Q'
    je .print_for_q
    cmp dx, 'r'
    je .print_for_r
    cmp dx, 'R'
    je .print_for_r
    cmp dx, 's'
    je .print_for_s
    cmp dx, 'S'
    je .print_for_s
    cmp dx, 't'
    je .print_for_t
    cmp dx, 'T'
    je .print_for_t
    cmp dx, 'u'
    je .print_for_u
    cmp dx, 'U'
    je .print_for_u
    cmp dx, 'v'
    je .print_for_v
    cmp dx, 'V'
    je .print_for_v
    cmp dx, 'w'
    je .print_for_w
    cmp dx, 'W'
    je .print_for_w
    cmp dx, 'x'
    je .print_for_x
    cmp dx, 'X'
    je .print_for_x
    cmp dx, 'y'
    je .print_for_y
    cmp dx, 'Y'
    je .print_for_y
    cmp dx, 'z'
    je .print_for_z
    cmp dx, 'Z'
    je .print_for_z
    cmp dx, '0'
    je .print_for_0
    cmp dx, '1'
    je .print_for_1
    cmp dx, '2'
    je .print_for_2
    cmp dx, '3'
    je .print_for_3
    cmp dx, '4'
    je .print_for_4
    cmp dx, '5'
    je .print_for_5
    cmp dx, '6'
    je .print_for_6
    cmp dx, '7'
    je .print_for_7
    cmp dx, '8'
    je .print_for_8
    cmp dx, '9'
    je .print_for_9
    jmp .iter_loop

.print_for_a:
    PRINT_STR map_a
    jmp     .iter_loop
.print_for_b:
    PRINT_STR map_b
    jmp     .iter_loop
.print_for_c:
    PRINT_STR map_c
    jmp     .iter_loop
.print_for_d:
    PRINT_STR map_d
    jmp     .iter_loop
.print_for_e:
    PRINT_STR map_e
    jmp     .iter_loop
.print_for_f:
    PRINT_STR map_f
    jmp     .iter_loop
.print_for_g:
    PRINT_STR map_g
    jmp     .iter_loop
.print_for_h:
    PRINT_STR map_h
    jmp     .iter_loop
.print_for_i:
    PRINT_STR map_i
    jmp     .iter_loop
.print_for_j:
    PRINT_STR map_j
    jmp     .iter_loop
.print_for_k:
    PRINT_STR map_k
    jmp     .iter_loop
.print_for_l:
    PRINT_STR map_l
    jmp     .iter_loop
.print_for_m:
    PRINT_STR map_m
    jmp     .iter_loop
.print_for_n:
    PRINT_STR map_n
    jmp     .iter_loop
.print_for_o:
    PRINT_STR map_o
    jmp     .iter_loop
.print_for_p:
    PRINT_STR map_p
    jmp     .iter_loop
.print_for_q:
    PRINT_STR map_q
    jmp     .iter_loop
.print_for_r:
    PRINT_STR map_r
    jmp     .iter_loop
.print_for_s:
    PRINT_STR map_s
    jmp     .iter_loop
.print_for_t:
    PRINT_STR map_t
    jmp     .iter_loop
.print_for_u:
    PRINT_STR map_u
    jmp     .iter_loop
.print_for_v:
    PRINT_STR map_v
    jmp     .iter_loop
.print_for_w:
    PRINT_STR map_w
    jmp     .iter_loop
.print_for_x:
    PRINT_STR map_x
    jmp     .iter_loop
.print_for_y:
    PRINT_STR map_y
    jmp     .iter_loop
.print_for_z:
    PRINT_STR map_z
    jmp     .iter_loop
.print_for_0:
    PRINT_STR map_0
    jmp     .iter_loop
.print_for_1:
    PRINT_STR map_1
    jmp     .iter_loop
.print_for_2:
    PRINT_STR map_2
    jmp     .iter_loop
.print_for_3:
    PRINT_STR map_3
    jmp     .iter_loop
.print_for_4:
    PRINT_STR map_4
    jmp     .iter_loop
.print_for_5:
    PRINT_STR map_5
    jmp     .iter_loop
.print_for_6:
    PRINT_STR map_6
    jmp     .iter_loop
.print_for_7:
    PRINT_STR map_7
    jmp     .iter_loop
.print_for_8:
    PRINT_STR map_8
    jmp     .iter_loop
.print_for_9:
    PRINT_STR map_9
    jmp     .iter_loop

.after_iter:
    PRINT_STR crlf_str
    xor r13, r13
    jmp .prompt

.beep_or_ignore:
    jmp .read_loop

.exit:
    PRINT_STR bye_str
    xor rax, rax
    add rsp, 32
    ret

section .data
align 2
init_str: dw 'I','n','g','r','e','s','e',' ','p','a','l','a','b','r','a','s',':',13,10,0
map_a: dw '.','-',' ',0
map_b: dw '-','.','.','.',' ',0
map_c: dw '-','.','-','.',' ',0
map_d: dw '-','.','.',' ',0
map_e: dw '.',' ',0
map_f: dw '.','.','-','.',' ',0
map_g: dw '-','-','.',' ',0
map_h: dw '.','.','.','.',' ',0
map_i: dw '.','.',' ',0
map_j: dw '.','-','-','-',' ',0
map_k: dw '-','.','-',' ',0
map_l: dw '.','-','.','.',' ',0
map_m: dw '-','-',' ',0
map_n: dw '-','.',' ',0
map_o: dw '-','-','-',' ',0
map_p: dw '.','-','-','.',' ',0
map_q: dw '-','-','.','-',' ',0
map_r: dw '.','-','.',' ',0
map_s: dw '.','.','.',' ',0
map_t: dw '-',' ',0
map_u: dw '.','.','-',' ',0
map_v: dw '.','.','.','-',' ',0
map_w: dw '.','-','-',' ',0
map_x: dw '-','.','.','-',' ',0
map_y: dw '-','.','-','-',' ',0
map_z: dw '-','-','.','.',' ',0
map_1: dw '.','-','-','-','-',' ',0
map_2: dw '.','.','-','-','-',' ',0
map_3: dw '.','.','.','-','-',' ',0
map_4: dw '.','.','.','.','-',' ',0
map_5: dw '.','.','.','.','.',' ',0
map_6: dw '-','.','.','.','.',' ',0
map_7: dw '-','-','.','.','.',' ',0
map_8: dw '-','-','-','.','.',' ',0
map_9: dw '-','-','-','-','.',' ',0
map_0: dw '-','-','-','-','-',' ',0
prompt_str: dw '>','>',' ',0
crlf_str: dw 13,10,0
bye_str: dw 13,10,'S','a','l','i','e','n','d','o',' ','c','o','n',' ','E','S','C','.',13,10,0

section .bss
align 2
key_buf: resw 2
line_buf: resw BUF_MAX

section .reloc
align 4
dd 0
