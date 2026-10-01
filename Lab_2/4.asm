format ELF64

public _start

SYS_WRITE = 1
SYS_EXIT  = 60
STDOUT    = 1

section '.data' writeable
    n = 4731757613
    buffer db 16 dup (0)               ; Буфер для перевода числа в строку

section '.text' executable

_start:
    xor r8, r8                          ; Обнуляем регистр суммы цифр
    mov rax, n                          ; Загружаем число в rax
    mov rdi, 10                         ; Делитель для последовательного извлечения цифр

.sum_loop:
    xor rdx, rdx                        ; Очищаем rdx перед делением rdx:rax
    div rdi                             ; rax = rax / 10, rdx = остаток (цифра)
    add r8, rdx                         ; Прибавляем цифру к сумме

    cmp rax, 0                          ; Проверяем, остались ли еще цифры
    jg .sum_loop

    mov rax, r8                         ; Передаем сумму цифр в rax для вывода
    call print_int

    mov rax, SYS_EXIT                   ; Завершение работы программы
    xor rdi, rdi
    syscall

print_int:
    xor rsi, rsi                        ; Индекс текущей позиции в буфере
    mov rdi, 10                         ; Делитель для перевода в ASCII

.to_ascii_loop:
    xor rdx, rdx
    div rdi                             ; Делим на 10 для получения цифры с конца
    add rdx, '0'                        ; Переводим цифру в ASCII-символ
    mov [buffer + rsi], dl              ; Записываем символ в буфер
    inc rsi

    cmp rax, 0                          ; Проверяем, перевели ли все число
    jg .to_ascii_loop

    mov [buffer + rsi], 10              ; Записываем символ переноса строки (\n)
    inc rsi
    mov r10, rsi                        ; Сохраняем полную длину строки (цифры + \n)

    ; Настройка указателей для разворота строки на месте
    mov rsi, buffer                     ; Левый указатель (на первую цифру)
    mov rdi, buffer
    add rdi, r10
    sub rdi, 2                          ; Правый указатель (на последнюю цифру перед \n)

.reverse_loop:
    cmp rsi, rdi                        ; Проверяем, не встретились ли указатели
    jge .print_result                   ; Переходим к выводу, когда разворот окончен

    ; Обмен символов местами через 8-битные регистры
    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al

    inc rsi                             ; Сдвигаем левый указатель вправо
    dec rdi                             ; Сдвигаем правый указатель влево
    jmp .reverse_loop

.print_result:
    ; Вывод развернутой строки с помощью sys_write
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, buffer
    mov rdx, r10                        ; Передаем длину строки
    syscall
    ret
