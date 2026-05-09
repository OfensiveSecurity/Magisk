#!/bin/bash

TARGET="sat.gob.mx"
echo -e "\e[1;34m[*] AUDITORÍA DE DNS E INTERCEPCIÓN (MODO MAGISK)...\e[0m"

# 1. Detectar IP Geográfica actual
MY_IP=$(curl -s https://ipapi.co/ip/)
MY_COUNTRY=$(curl -s https://ipapi.co/country_name/)
echo "[i] Tu IP Pública: $MY_IP ($MY_COUNTRY)"

# 2. Resolución Local (Usando los ajustes de Android/Magisk)
RES_IP=$(nslookup $TARGET | grep "Address" | tail -n 1 | awk '{print $2}')
echo "[*] Resolución vía DoH/Magisk: $RES_IP"

# 3. Comparar con DNS Público de Google (8.8.8.8) para verificar consistencia
REF_IP=$(nslookup $TARGET 8.8.8.8 | grep "Address" | tail -n 1 | awk '{print $2}')
echo "[*] Resolución de referencia (Google): $REF_IP"

# 4. Diagnóstico Forense
if [ "$RES_IP" != "$REF_IP" ]; then
    echo -e "\e[1;33m[!] DISCREPANCIA DETECTADA:\e[0m Tu DoH está resolviendo una IP distinta."
    echo "Esto puede causar el Error 403 si el WAF del SAT detecta tráfico 'anómalo'."
else
    echo -e "\e[1;32m[✓] DNS CONSISTENTE.\e[0m La resolución parece normal."
fi

# 5. Verificación de Bloqueo de Nodo
if [[ "$MY_COUNTRY" != "Mexico" ]]; then
    echo -e "\e[1;31m[!] ALERTA GEOGRÁFICA:\e[0m Estás navegando fuera de México."
    echo "Muchos servicios del SAT bloquean peticiones internacionales por seguridad."
fi
