format ELF64

public _start

SYS_WRITE = 1
SYS_EXIT  = 60
STDOUT    = 1

section '.data' writeable
    m = 14
    k = 29
    n = m * k

    buffer db n dup ('*')
    newline db 10

section '.text' executable
_start:
    mov r8, 1                           ; Сколько символов выводить в текущей строке (начинаем с 1)
    mov r9, buffer                      ; r9 — текущий указатель на позицию в буфере

loop_triangle:
    ; Вывод r8 символов из текущей позиции буфера
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, r9
    mov rdx, r8
    syscall

    ; Вывод переноса строки (\n)
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, newline
    mov rdx, 1
    syscall

    add r9, r8                          ; Сдвигаем указатель в буфере вперед на r8 напечатанных байт
    inc r8                              ; В следующей строке нужно на 1 символ больше

    ; Проверяем, остались ли еще символы в буфере
    mov rax, buffer
    add rax, n                          ; rax = адрес конца буфера (buffer + 406)
    cmp r9, rax                         ; Сравниваем текущий указатель r9 с концом буфера
    jl loop_triangle

    ; Завершение программы
    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall
