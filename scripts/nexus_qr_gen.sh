# 1. Instalar la herramienta necesaria
pkg install qrencode -y

# 2. Crear el script generador
cat <<EOF > ~/scripts/nexus_qr_gen.sh
#!/bin/bash

# Obtener la IP local de la interfaz wlan0 o rmnet
IP_LOCAL=\$(ifconfig | grep -A 1 'wlan0' | grep 'inet ' | awk '{print \$2}')

if [ -z "\$IP_LOCAL" ]; then
    # Intento con la interfaz de datos móviles si no hay WiFi
    IP_LOCAL=\$(ifconfig | grep -A 1 'rmnet' | grep 'inet ' | awk '{print \$2}')
fi

URL="http://\$IP_LOCAL:8080"

echo -e "\e[1;34m[*] GENERANDO ACCESO RÁPIDO AL DASHBOARD...\e[0m"
echo -e "\e[1;32m[URL]: \$URL\e[0m\n"

# Generar el código QR en la terminal
qrencode -t ANSIUTF8 "\$URL"

echo -e "\n[i] Escanea este código para abrir el monitor en tu laptop."
EOF

chmod +x ~/scripts/nexus_qr_gen.sh
