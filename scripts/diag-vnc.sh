#!/bin/bash

echo "===== TIGERVNC ====="

echo
echo "[1] Ejecutables reales:"
ls -l /usr/bin/tigervncserver /usr/bin/tigervncpasswd 2>&1

echo
echo "[2] Paquetes:"
dpkg -L tigervnc-standalone-server 2>/dev/null | grep -E 'tigervncserver|vncser>
dpkg -L tigervnc-tools 2>/dev/null | grep -E 'tigervncpasswd|vncpasswd'

echo
echo "[3] Alternatives:"
ls -la /etc/alternatives/vncserver 2>&1
ls -la /etc/alternatives/vncpasswd 2>&1

echo
echo "[4] Base alternatives:"
ls -la /var/lib/dpkg/alternatives/vncserver 2>&1
ls -la /var/lib/dpkg/alternatives/vncpasswd 2>&1

echo
echo "[5] PATH:"
echo "$PATH"

echo
echo "[6] Comandos:"
command -v tigervncserver || echo "tigervncserver NO"
command -v tigervncpasswd || echo "tigervncpasswd NO"
command -v vncserver || echo "vncserver NO"
command -v vncpasswd || echo "vncpasswd NO"

echo
echo "===== FIN ====="
