.syntax unified
.cpu cortex-m33
.fpu fpv5-sp-d16
.thumb

.global g_pfnVectors
.global Default_Handler

/* Símbolos definidos en el Linker Script (.ld) */
.word _sidata
.word _sdata
.word _edata
.word _sbss
.word _ebss
.word _estack

.section .text.Reset_Handler
.weak Reset_Handler
.type Reset_Handler, %function

Reset_Handler:
  /* 1. Configurar el puntero de pila (Stack Pointer) */
  ldr   sp, =_estack

  /* 2. Copiar la sección .data de FLASH a RAM */
  movs  r1, #0
  b     LoopCopyDataInit

CopyDataInit:
  ldr   r3, =_sidata
  ldr   r3, [r3, r1]
  str   r3, [r0, r1]
  adds  r1, r1, #4

LoopCopyDataInit:
  ldr   r0, =_sdata
  ldr   r3, =_edata
  adds  r2, r0, r1
  cmp   r2, r3
  bcc   CopyDataInit

  /* 3. Limpiar la sección .bss (poner a cero) */
  ldr   r2, =_sbss
  b     LoopFillZerobss

FillZerobss:
  movs  r3, #0
  str   r3, [r2]
  adds  r2, r2, #4

LoopFillZerobss:
  ldr   r3, =_ebss
  cmp   r2, r3
  bcc   FillZerobss

  /* 4. Habilitar la FPU (Unidad de Punto Flotante) - Vital para IA */
  ldr.w r0, =0xE000ED88    /* CPACR Register */
  ldr   r1, [r0]
  orr   r1, r1, #(0xF << 20)
  str   r1, [r0]
  dsb
  isb

  /* 5. Llamar al constructor de C++ y luego a main */
  bl    main_cpp
  bx    lr
.size Reset_Handler, .-Reset_Handler

/* Tabla de Vectores de Interrupción */
.section .isr_vector,"a",%progbits
.type g_pfnVectors, %object

g_pfnVectors:
  .word _estack            /* Dirección inicial de la pila */
  .word Reset_Handler      /* Reset Handler */
  .word NMI_Handler
  .word HardFault_Handler
  /* ... resto de vectores según el PDF ... */
