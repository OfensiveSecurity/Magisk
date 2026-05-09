#!/bin/bash

# 1. Iniciar Grabación Silenciosa (Formato ligero para streaming)
echo "[*] INICIANDO ESCUCHA AMBIENTAL (GHOST-EAR)..."

# 2. Transmitir vía Netcat al Dashboard
# El audio se enviará en trozos de 10 segundos para no saturar la memoria
while true; do
    termux-microphone-record -l 10 -f ~/nexus/logs/ambient_temp.m4a
    # Sincroniza el archivo con el servidor Flask
    mv ~/nexus/logs/ambient_temp.m4a ~/nexus/web/static/stream.m4a
    echo "[✓] Audio de 10s actualizado en Dashboard."
done
