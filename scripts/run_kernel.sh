#!/bin/bash

echo "🚀 Iniciando Emulación de Kernel GTC 2026..."

# Verificamos que el binario exista
if [ ! -f "kernel.bin" ]; then
    echo "[!] Error: No se encontró kernel.bin. Compila primero."
    exit 1
fi

# Ejecutar QEMU apuntando al binario del kernel
# -kernel: Carga directamente el binario multiboot
# -display: Usa modo texto o gráfico según tu configuración
qemu-system-i386 -kernel kernel.bin
