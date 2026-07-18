bits 32
section .text
        align 4
        dd 0x1BADB002              ; Magic number para Multiboot
        dd 0x00
        dd - (0x1BADB002 + 0x00)   ; Checksum

global start
extern kernel_main

start:
        cli                         ; Bloquear interrupciones
        call kernel_main            ; Llamar a tu función en C
        hlt                         ; Detener el procesador
