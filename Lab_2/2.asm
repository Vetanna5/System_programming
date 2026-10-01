format ELF64

public _start

SYS_WRITE = 1
SYS_EXIT  = 60
STDOUT    = 1

section '.data' writeable
    m = 14
    k = 29
    n = m * k

    buffer db n dup ('*')               ; Буфер, заполненный символами '*'
    newline db 10                       ; Символ переноса строки (\n)

section '.text' executable
_start:
    xor r8, r8                          ; Счетчик напечатанных строк

loop_matrix:
    ; Выводим k символов (одну строку матрицы)
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, buffer
    mov rdx, k
    syscall

    ; Выводим символ переноса строки
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, newline
    mov rdx, 1
    syscall

    inc r8                              ; Увеличиваем счетчик строк
    cmp r8, m                           ; Проверяем, достигли ли m строк
    jl loop_matrix                      ; Если напечатано меньше m строк — повторяем

    ; Завершение программы с кодом 0
    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall
