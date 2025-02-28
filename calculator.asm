section .data
    prompt1 db "Enter first number: ", 0
    prompt1_len equ $ - prompt1
    
    prompt2 db "Enter second number: ", 0
    prompt2_len equ $ - prompt2
    
    op_prompt db "Enter operation (+, -, *, /): ", 0
    op_prompt_len equ $ - op_prompt
    
    result_msg db "Result: ", 0
    result_msg_len equ $ - result_msg
    
    error_msg db "Error: Division by zero!", 0
    error_msg_len equ $ - error_msg
    
    newline db 10, 0
    
section .bss
    num1 resq 1
    num2 resq 1
    operation resb 2
    buffer resb 20
    
section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt1
    mov rdx, prompt1_len
    syscall
    
    call read_number
    mov [num1], rax
    
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt2
    mov rdx, prompt2_len
    syscall
    
    call read_number
    mov [num2], rax
    
    mov rax, 1
    mov rdi, 1
    mov rsi, op_prompt
    mov rdx, op_prompt_len
    syscall
    
    mov rax, 0
    mov rdi, 0
    mov rsi, operation
    mov rdx, 2
    syscall
    
    mov rax, 1
    mov rdi, 1
    mov rsi, result_msg
    mov rdx, result_msg_len
    syscall
    
    movzx rax, byte [operation]
    
    cmp al, '+'
    je add_nums
    
    cmp al, '-'
    je sub_nums
    
    cmp al, '*'
    je mul_nums
    
    cmp al, '/'
    je div_nums
    
    jmp exit
    
add_nums:
    mov rax, [num1]
    add rax, [num2]
    jmp print_result
    
sub_nums:
    mov rax, [num1]
    sub rax, [num2]
    jmp print_result
    
mul_nums:
    mov rax, [num1]
    imul rax, [num2]
    jmp print_result
    
div_nums:
    cmp qword [num2], 0
    je division_by_zero
    
    mov rax, [num1]
    cqo
    idiv qword [num2]
    jmp print_result
    
division_by_zero:
    mov rax, 1
    mov rdi, 1
    mov rsi, error_msg
    mov rdx, error_msg_len
    syscall
    jmp exit
    
print_result:
    call print_number
    
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
exit:
    mov rax, 60
    xor rdi, rdi
    syscall

read_number:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 20
    syscall
    
    xor rcx, rcx
    xor rax, rax
    xor rbx, rbx
    mov rsi, buffer
    
    mov bl, byte [rsi]
    cmp bl, '-'
    jne parse_loop
    inc rsi
    mov rdx, 1
    jmp start_parse
    
parse_loop:
    mov bl, byte [rsi + rcx]
    
    cmp bl, 10
    je parse_done
    
    cmp bl, 0
    je parse_done
    
    sub bl, '0'
    
    imul rax, 10
    add rax, rbx
    
    inc rcx
    jmp parse_loop
    
start_parse:
    xor rcx, rcx
    xor rax, rax
    jmp parse_loop
    
parse_done:
    cmp rdx, 1
    jne read_done
    neg rax
    
read_done:
    ret

print_number:
    cmp rax, 0
    jge positive
    
    push rax
    mov rax, 1
    mov rdi, 1
    mov byte [buffer], '-'
    mov rsi, buffer
    mov rdx, 1
    syscall
    pop rax
    neg rax
    
positive:
    mov rcx, buffer
    add rcx, 19
    mov byte [rcx], 0
    
    mov rbx, 10
    
digit_loop:
    dec rcx
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rcx], dl
    
    test rax, rax
    jnz digit_loop
    
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, buffer
    add rdx, 19
    sub rdx, rcx
    syscall
    
    ret

