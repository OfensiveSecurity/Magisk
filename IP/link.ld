ENTRY(start)                /* Definimos 'start' de boot.asm como el punto de inicio */

SECTIONS
{
    . = 0x100000;           /* El kernel se cargará en 1MB de memoria */

    .text : {
        *(.text)            /* Todo el código ejecutable de C y ASM */
    }

    .rodata : {
        *(.rodata)          /* Datos de solo lectura (como tus mensajes de texto) */
    }

    .data : {
        *(.data)            /* Variables globales inicializadas */
    }

    .bss : {
        *(.bss)             /* Variables globales no inicializadas */
    }
}
