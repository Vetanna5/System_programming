format ELF64

public _start

section '.data' writeable
    msg db 'FbsokKqcURDycPFLeXnlZEXWllfrioUStB', 10
    msg_len = $ - msg                   ; Расчет общей длины строки (включая перенос)

section '.text' executable
_start:
    mov rsi, msg                        ; Левый указатель (начало строки)
    mov rdi, msg + msg_len - 2          ; Правый указатель (последняя буква перед \n)

reverse_loop:
    cmp rsi, rdi                        ; Проверяем, не встретились ли указатели
    jge print_result                    ; Если встретились или пересеклись — переходим к выводу

    ; Обмен символов местами (swap)
    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al

    inc rsi                             ; Сдвигаем левый указатель вправо
    dec rdi                             ; Сдвигаем правый указатель влево
    jmp reverse_loop

print_result:
    ; Системный вызов sys_write (1) для вывода строки в stdout (1)
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    ; Системный вызов sys_exit (60) с кодом 0
    mov rax, 60
    xor rdi, rdi
    syscall
