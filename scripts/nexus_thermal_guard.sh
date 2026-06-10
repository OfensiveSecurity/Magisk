#!/bin/bash

# Configuración de Umbrales
TEMP_LIMIT=45000 # 45°C (el sistema suele reportar en miligrados)
THERMAL_ZONE="/sys/class/thermal/thermal_zone0/temp"
LOG_FILE="/data/data/com.termux/files/home/nexus/logs/thermal.log"

# Función de Kill-Switch
activate_kill_switch() {
    local current_temp=$1
    echo "[!!!] ALERTA TÉRMICA: ${current_temp:0:2}°C detectados. Iniciando SHUTDOWN de servicios..." >> $LOG_FILE
    
    # 1. Detener procesos de red pesados (Nmap, Scapy, Sniffers)
    pkill -f nmap
    pkill -f scapy
    pkill -f python3 # Detiene el correlacionador y otros módulos de Python
    
    # 2. Desactivar interfaces de red (Requiere root si es fuera de Termux, 
    # de lo contrario detiene los servicios internos del Nexus)
    curl -s -X POST "http://127.0.0.1:8080/api/notifications" \
         -H "Content-Type: application/json" \
         -d "{\"event\": \"THERMAL_SHUTDOWN\", \"temp\": \"${current_temp:0:2}C\", \"status\": \"CRITICAL\"}"
    
    # 3. Notificación visual en consola
    echo -e "\e[31m[!] NEXUS CORE: SISTEMA ENFRIANDO. PROCESOS DETENIDOS.\e[0m"
}

# Bucle de Monitoreo
while true; do
    if [ -f "$THERMAL_ZONE" ]; then
        CURRENT_TEMP=$(cat "$THERMAL_ZONE")
        
        if [ "$CURRENT_TEMP" -gt "$TEMP_LIMIT" ]; then
            activate_kill_switch "$CURRENT_TEMP"
            sleep 300 # Esperar 5 minutos para que baje la temperatura
        fi
    fi
    sleep 10 # Verificación cada 10 segundos
done
