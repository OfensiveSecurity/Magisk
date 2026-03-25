#!/bin/bash

echo -e "\e[1;34m[+]--- INICIANDO DIAGNÓSTICO DE SISTEMA (NEXUS v3.3) ---[+]\e[0m"

# 1. Verificación Térmica (Hardware)
TEMP=$(cat /sys/class/thermal/thermal_zone0/temp | awk '{print $1/1000}')
echo -n "[*] Temperatura CPU: $TEMP°C "
if (( $(echo "$TEMP < 40" | bc -l) )); then echo -e "\e[1;32m[OK]\e[0m"; else echo -e "\e[1;33m[WARM]\e[0m"; fi

# 2. Verificación de Energía (Batería)
BATT=$(cat /sys/class/power_supply/battery/capacity)
STAT=$(cat /sys/class/power_supply/battery/status)
echo -n "[*] Nivel de Batería: $BATT% ($STAT) "
if [ "$BATT" -gt 20 ]; then echo -e "\e[1;32m[SAFE]\e[0m"; else echo -e "\e[1;31m[CRITICAL]\e[0m"; fi

# 3. Auditoría de Geolocalización (Anti-403 SAT)
GEO=$(curl -s --max-time 2 https://ipapi.co/country_name/)
echo -n "[*] Ubicación de Red: $GEO "
if [ "$GEO" == "Mexico" ]; then 
    echo -e "\e[1;32m[READY (No-403)]\e[0m"
else 
    echo -e "\e[1;31m[ALERTA: REVISA DNS SOBRE HTTPS EN MAGISK]\e[0m"
fi

# 4. Estado del Dashboard Web
if pgrep -f "nexus_web_dashboard" > /dev/null; then
    echo -e "[*] Dashboard Web: \e[1;32mACTIVO (Puerto 8080)\e[0m"
else
    echo -e "[*] Dashboard Web: \e[1;31mINACTIVO\e[0m"
fi

# 5. Conectividad GitHub (Evidencias)
if git ls-remote origin &>-; then
    echo -e "[*] Sincronización GitHub: \e[1;32mCONECTADO\e[0m"
else
    echo -e "[*] Sincronización GitHub: \e[1;31mERROR (Revisa Token/Red)\e[0m"
fi

echo -e "\e[1;34m[+]--------------------------------------------------[+]\e[0m"
