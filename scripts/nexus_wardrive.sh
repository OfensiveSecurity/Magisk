#!/bin/bash
# NEXUS WARDRIVE ENGINE v1.0

# 1. Poner interfaz en modo monitor (requiere Magisk/Kernel compatible)
su -c "airmon-ng start wlan0"

# 2. Iniciar escaneo y vinculación GPS
echo "[*] INICIANDO RECONOCIMIENTO INALÁMBRICO PASIVO..."

# Capturamos BSSID, ESSID, Canal y Cifrado
termux-location -p network | jq '.' > ~/nexus/loot/last_gps.json
su -c "airodump-ng wlan0mon --write ~/nexus/loot/wardrive_log --output-format csv" &

echo "[✓] ESCANEO ACTIVO: Guardando redes en el sector."
