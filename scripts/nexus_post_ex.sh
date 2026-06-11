#!/bin/bash
# NEXUS POST-EXPLOITATION SUITE v1.0

echo "[*] SESIÓN ESTABLECIDA. EJECUTANDO RECONOCIMIENTO DE PRIVILEGIOS..."

# 1. Identidad y Sistema
whoami && id
uname -a
cat /etc/issue

# 2. Red y Conexiones (Buscando Pivoting)
ip a || ifconfig
netstat -tunlp

# 3. Enumeración de SUID (Buscando Escala de Privilegios)
find / -perm -u=s -type f 2>/dev/null | head -n 10

# 4. Enviar todo al Loot-Logger y al Reporte PDF
echo "[V] POST-EX SITUATION ROOM UPDATED"
