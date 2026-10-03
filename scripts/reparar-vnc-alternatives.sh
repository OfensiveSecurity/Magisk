#!/bin/bash

echo "=== EJECUTABLES TIGERVNC ==="

echo
echo "[1] tigervncpasswd"
command -v tigervncpasswd || echo "NO ENCONTRADO"

echo
echo "[2] tigervncserver"
command -v tigervncserver || echo "NO ENCONTRADO"

echo
echo "[3] Archivos del paquete"
dpkg -L tigervnc-tools 2>/dev/null | grep -E 'tigervncpasswd|vncpasswd'
dpkg -L tigervnc-standalone-server 2>/dev/null | grep -E 'tigervncserver|vncserver'

echo
echo "[4] Base de alternatives"
ls -la /var/lib/dpkg/alternatives/vncpasswd 2>&1
ls -la /var/lib/dpkg/alternatives/vncserver 2>&1

echo
echo "[5] Destinos actuales"
ls -la /etc/alternatives/vncpasswd 2>&1
ls -la /etc/alternatives/vncserver 2>&1

echo
echo "=== FIN ==="
