#!/bin/bash
# WATCHDOG DE MEMORIA NEXUS v1.0

THRESHOLD=200

while true; do
    FREE_RAM=$(free -m | awk '/Mem:/ { print $4 }')
    
    if [ "$FREE_RAM" -lt "$THRESHOLD" ]; then
        # 1. Notificar al Dashboard (Activa sonido en laptop)
        echo "LOW_MEMORY_CRITICAL" > ~/nexus/logs/alarm_status.tmp
        
        # 2. Aviso por Voz en el Moto E13 (Termux:API)
        termux-tts-speak "Alerta de memoria. RAM baja en el Nexo. Cierra procesos."
        
        # 3. Vibración de emergencia
        termux-vibrate -d 500 -f
        
        sleep 5 # Pausa para evitar bucle de alertas
    else
        echo "RAM_STABLE" > ~/nexus/logs/alarm_status.tmp
    fi
    sleep 2
done
