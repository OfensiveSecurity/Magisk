#!/bin/bash

# Configuración
INTERFACE="wlan0"
THRESHOLD=500
PYTHON_SCRIPT="/data/data/com.termux/files/home/nexus/scripts/nexus_performance_correlator.py"
LOG_FILE="/data/data/com.termux/files/home/nexus/logs/trigger.log"

# Dominios Excluidos (Lista Blanca)
WHITE_LIST=("sat.gob.mx" "banxico.org.mx" "gob.mx")

check_whitelist() {
    for domain in "${WHITE_LIST[@]}"; do
        # Verifica si hay sockets abiertos hacia estos dominios
        if ss -ntp | grep -q "$domain"; then
            return 0 # Dominio encontrado, ignorar trigger
        fi
    done
    return 1 # Limpio, proceder con monitoreo
}

echo "[*] NEXUS MONITOR v2.0: Vigilando con Lista Blanca activa..."

while true; do
    # 1. Obtener pps
    R1=$(cat /proc/net/dev | grep "$INTERFACE" | awk '{print $2}')
    sleep 1
    R2=$(cat /proc/net/dev | grep "$INTERFACE" | awk '{print $2}')
    DIFF=$((R2 - R1))
    
    if [ "$DIFF" -gt "$THRESHOLD" ]; then
        # 2. Verificar si el tráfico es "Ruido Blanco" (Trámites)
        if check_whitelist; then
            echo "[i] TRÁFICO EXCLUIDO: Actividad en dominio de confianza detectada." >> $LOG_FILE
        else
            echo "[!] PICO SOSPECHOSO: $DIFF pps. Activando Correlacionador..." >> $LOG_FILE
            python3 "$PYTHON_SCRIPT" &
            sleep 120 
        fi
    fi
done
