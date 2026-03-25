#!/bin/bash

# 1. Registrar hora de inicio (si no existe)
START_FILE="/data/data/com.termux/files/home/nexus/.exam_start"
if [ ! -f "$START_FILE" ]; then
    date +%s > "$START_FILE"
fi

START_TIME=$(cat "$START_FILE")
CURRENT_TIME=$(date +%s)
ELAPSED=$((CURRENT_TIME - START_TIME))
TOTAL_EXAM=$((24 * 3600)) # 24 Horas en segundos
REMAINING=$((TOTAL_EXAM - ELAPSED))

# 2. Convertir a formato legible
if [ "$REMAINING" -gt 0 ]; then
    H=$((REMAINING / 3600))
    M=$(((REMAINING % 3600) / 60))
    S=$((REMAINING % 60))
    echo -e "\e[1;31m[⏱️] TIEMPO RESTANTE DE EXAMEN: ${H}h ${M}m ${S}s\e[0m"
    
    # Alerta de fase final (últimas 2 horas)
    if [ "$H" -lt 2 ]; then
        echo -e "\e[5;31m[!] FASE CRÍTICA: RECOLECTA PRUEBAS Y CAPTURAS AHORA.\e[0m"
    fi
else
    echo -e "\e[1;37;41m[X] TIEMPO AGOTADO: INICIA REDACCIÓN DE REPORTE FINAL.\e[0m"
fi
