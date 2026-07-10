#!/bin/bash

# Nombre del archivo generado por tu Makefile
PROJECT_BINARY="kernel.elf"

echo "⚡ Iniciando proceso de carga al STM32C5A3ZG..."

# Ejecutamos OpenOCD
# -f: Especifica la interfaz (ej. ST-Link V2/V3)
# -f: Especifica el target (el chip STM32C5)
openocd -f interface/stlink.cfg \
        -f target/stm32c5x.cfg \
        -c "program $PROJECT_BINARY verify reset exit"

if [ $? -eq 0 ]; then
    echo "✅ ¡Éxito! El kernel está corriendo en el hardware."
else
    echo "❌ Error al flashear. Revisa la conexión del ST-Link."
fi
