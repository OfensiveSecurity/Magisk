#!/bin/bash

TARGET="sat.gob.mx"
DNS_SERVER=$(getprop net.dns1) # Obtiene el DNS configurado en Android

echo -e "\e[1;34m[*] Auditando Resolución DNS de NEXUS...\e[0m"

# 1. Verificar Servidor DNS actual
echo "[i] Servidor DNS activo: $DNS_SERVER"

# 2. Prueba de Resolución (nslookup)
echo "[*] Resolviendo $TARGET..."
nslookup $TARGET

# 3. Verificar si hay interceptores en /etc/hosts
if grep -q "$TARGET" /etc/hosts; then
    echo -e "\e[1;31m[!] ALERTA: Intercepción detectada en /etc/hosts\e[0m"
    grep "$TARGET" /etc/hosts
else
    echo "[✓] Archivo hosts limpio."
fi

# 4. Prueba de conectividad directa (Ping corto)
ping -c 3 $TARGET > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "\e[1;32m[✓] Conectividad ICMP exitosa con el servidor.\e[0m"
else
    echo -e "\e[1;33m[!] Bloqueo ICMP detectado (Común en firewalls estatales).\e[0m"
fi
