#!/bin/bash

# Configuración
SOURCE_DIR="/data/data/com.termux/files/home/nexus/logs"
DEST_DIR="/storage/emulated/0/Download/NEXUS_ARCHIVE"
THRESHOLD=10
DASHBOARD_URL="http://127.0.0.1:8080/api/notifications" # URL de tu Dashboard NEXUS

# Función de Notificación
send_nexus_alert() {
    local status=$1
    local message=$2
    curl -X POST "$DASHBOARD_URL" \
         -H "Content-Type: application/json" \
         -d "{\"system\": \"NEXUS CORE v3.0\", \"device\": \"Moto E13\", \"status\": \"$status\", \"msg\": \"$message\", \"timestamp\": \"$(date)\"}"
}

# 1. Verificar espacio
FREE_SPACE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$FREE_SPACE" -gt "$((100 - THRESHOLD))" ]; then
    # Iniciar Offload
    mkdir -p "$DEST_DIR"
    COUNT=$(find "$SOURCE_DIR" -name "*.pcap" -size +500M | wc -l)
    
    find "$SOURCE_DIR" -name "*.pcap" -size +500M -exec mv {} "$DEST_DIR" \;
    rm -rf /data/data/com.termux/files/usr/tmp/*
    
    # Notificar Éxito
    send_nexus_alert "CLEAN_SUCCESS" "Se movieron $COUNT archivos .pcap y se limpio /tmp."
else
    # Notificar Estado Nominal (Opcional, se puede comentar para menos ruido)
    send_nexus_alert "NOMINAL" "Espacio suficiente: $((100 - FREE_SPACE))% libre."
fi
