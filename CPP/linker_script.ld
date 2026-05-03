/* Definición de memorias para STM32C5A3ZG */
MEMORY
{
  FLASH (rx)      : ORIGIN = 0x08000000, LENGTH = 1024K
  RAM (xrw)       : ORIGIN = 0x20000000, LENGTH = 256K
}

/* Secciones de salida */
SECTIONS
{
  .text :
  {
    KEEP(*(.isr_vector)) /* Tabla de vectores de interrupción */
    *(.text*)           /* Código del programa */
    *(.rodata*)         /* Datos de solo lectura */
    _etext = .;
  } > FLASH

  .data : 
  {
    _sdata = .;
    *(.data*)           /* Variables inicializadas */
    _edata = .;
  } > RAM AT > FLASH

  .bss :
  {
    _sbss = .;
    *(.bss*)            /* Variables no inicializadas */
    _ebss = .;
  } > RAM
}
