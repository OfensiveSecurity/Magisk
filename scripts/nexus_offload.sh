#!/bin/bash

# Configuración de Rutas
SOURCE_DIR="/data/data/com.termux/files/home/nexus/logs"
DEST_DIR="/storage/emulated/0/Download/NEXUS_ARCHIVE" # Ruta común en Android (ajustar según SD)
THRESHOLD=10
LOG_FILE="/data/data/com.termux/files/home/nexus/offload.log"

# 1. Verificar espacio libre en la partición raíz
FREE_SPACE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$FREE_SPACE" -gt "$((100 - THRESHOLD))" ]; then
    echo "[!] Alerta: Espacio crítico ($FREE_SPACE%). Iniciando Offload..." >> $LOG_FILE
    
    # Crear directorio de destino si no existe
    mkdir -p "$DEST_DIR"

    # 2. Mover archivos .pcap mayores a 500MB
    find "$SOURCE_DIR" -name "*.pcap" -size +500M -exec mv {} "$DEST_DIR" \;
    
    # 3. Limpiar caché de compilación excedente
    rm -rf /data/data/com.termux/files/usr/tmp/*
    
    echo "[✓] Offload completado el $(date)" >> $LOG_FILE
else
    echo "[i] Espacio estable ($((100 - FREE_SPACE))% libre). No se requiere acción." >> $LOG_FILE
fi
