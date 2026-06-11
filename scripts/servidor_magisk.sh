#!/bin/bash

# Carpeta donde guardamos los APKs compilados
DIR_COMPILACION="$HOME/Magisk_Reciente"
PUERTO=8080

# Obtener la IP local de tu Android (Termux)
IP_LOCAL=$(ifconfig wlan0 | grep 'inet ' | awk '{print $2}')

echo "------------------------------------------------"
echo "🚀 Servidor de Distribución de Magisk Activo"
echo "📂 Compartiendo: $DIR_COMPILACION"
echo "🌐 Accede desde otro móvil a: http://$IP_LOCAL:$PUERTO"
echo "------------------------------------------------"
echo "[*] Presiona CTRL+C para detener el servidor."

# Iniciar el servidor de Python
cd "$DIR_COMPILACION" && python -m http.server $PUERTO
