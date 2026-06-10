#!/bin/bash

# Configuración
INTERFACE="wlan0"
THRESHOLD=500 # Paquetes por segundo para activar el trigger
PYTHON_SCRIPT="/data/data/com.termux/files/home/nexus/scripts/nexus_performance_correlator.py"
LOG_FILE="/data/data/com.termux/files/home/nexus/logs/trigger.log"

echo "[*] NEXUS MONITOR: Vigilando interfaz $INTERFACE..."

while true; do
    # 1. Obtener RX y TX de paquetes
    R1=$(cat /proc/net/dev | grep "$INTERFACE" | awk '{print $2}')
    sleep 1
    R2=$(cat /proc/net/dev | grep "$INTERFACE" | awk '{print $2}')
    
    # 2. Calcular diferencia (pps aproximado)
    DIFF=$((R2 - R1))
    
    if [ "$DIFF" -gt "$THRESHOLD" ]; then
        echo "[!] PICO DETECTADO: $DIFF pps. Activando Correlacionador..." >> $LOG_FILE
        
        # 3. Ejecutar el análisis de Python en segundo plano
        python3 "$PYTHON_SCRIPT" &
        
        # 4. Notificar al Dashboard
        curl -s -X POST "http://127.0.0.1:8080/api/notifications" \
             -H "Content-Type: application/json" \
             -d "{\"event\": \"TRAFFIC_TRIGGER\", \"value\": \"$DIFF pps\", \"action\": \"PYTHON_CORRELATION_START\"}"
             
        # Pausa para evitar re-disparos inmediatos durante el análisis
        sleep 120 
    fi
done
