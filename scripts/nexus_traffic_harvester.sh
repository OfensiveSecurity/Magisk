#!/bin/bash
# NEXUS TRAFFIC SNIFFER v1.0

INTERFACE="wlan0"
DUMP_FILE="~/nexus/loot/network_capture.pcap"

echo "[*] INICIANDO SNIFFER DE ARCHIVOS (PDF/DOCX)..."

# Capturar solo tráfico que contenga firmas de archivos comunes
# 25 50 44 46 (PDF) | 50 4B 03 04 (DOCX/ZIP)
su -c "tcpdump -i $INTERFACE -A -nn -l | grep -Ei 'PDF|PK' >> ~/nexus/logs/file_traffic.log" &

# Guardar paquetes completos para análisis posterior en Wireshark (Laptop)
su -c "tcpdump -i $INTERFACE -w $DUMP_FILE -C 10 -W 3" &

echo "[✓] CAPTURA ACTIVA: Los paquetes se guardan en el Nexo."
