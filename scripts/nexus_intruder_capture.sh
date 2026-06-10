#!/bin/bash
# NEXUS-HONEYTRAP v1.0

# 1. Capturar Foto Silenciosa (Cámara Frontal)
# Guardamos la evidencia en una carpeta oculta antes del envío
termux-camera-photo -c 1 ~/nexus/evidence/intruder_$(date +%H%M%S).jpg

# 2. Obtener Coordenadas GPS Exactas
LOCATION=$(termux-location -p network)
echo "$LOCATION" > ~/nexus/evidence/last_location.json

# 3. Envío Crítico (Exfiltración de Emergencia)
# Intentamos subir la foto a tu GitHub o enviarla por el Dashboard
curl -F "file=@/data/data/com.termux/files/home/nexus/evidence/intruder_latest.jpg" http://TU_IP_SERVER:8080/intruder_alert

# 4. Bloqueo Total (Kernel Panic Simulado)
# El teléfono se congela para que el intruso no pueda borrar nada
su -c "input keyevent 26" # Bloquear pantalla
su -c "am force-stop com.android.settings" # Cerrar ajustes
