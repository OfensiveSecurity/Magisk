#!/bin/bash

echo -e "\e[1;34m[*] INICIANDO PROTOCOLO DE REBLOQUEO (NEXUS-UNLOCK)...\e[0m"

# 1. Desactivar Modo Avión (Requiere Root/Magisk)
su -c "settings put global airplane_mode_on 0"
su -c "am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false"
echo "[✓] Radio de red restaurada."

# 2. Reiniciar Servicios de Red (Purga de DNS)
su -c "svc data enable"
echo "[✓] Datos móviles reactivados."

# 3. Limpieza Forense
rm -f /data/data/com.termux/files/home/nexus/logs/network_lock.tmp
echo "REBLOQUEO_MANUAL: $(date)" >> /data/data/com.termux/files/home/nexus/logs/network_security.log

# 4. Verificación de IP Inmediata
sleep 3
NEW_COUNTRY=$(curl -s --max-time 3 https://ipapi.co/country_name/)
echo -e "\e[1;32m[!] SISTEMA RESTAURADO. Ubicación detectada: $NEW_COUNTRY\e[0m"

if [[ "$NEW_COUNTRY" != "Mexico" ]]; then
    echo -e "\e[1;31m[!] ADVERTENCIA: Sigues fuera de México. Apaga el DoH en Magisk.\e[0m"
fi
