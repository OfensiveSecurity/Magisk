#!/bin/bash

echo "===== DIAGNOSTICO VNC ====="

echo
echo "[1] EJECUTABLES REALES"
ls -l /usr/bin/tigervncserver 2>&1
ls -l /usr/bin/tigervncpasswd 2>&1

echo
echo "[2] BUSQUEDA"
find /usr -type f \( \
  -name tigervncserver -o \
  -name tigervncpasswd \
\) -ls 2>/dev/null

echo
echo "[3] PAQUETES"
dpkg -L tigervnc-standalone-server 2>/dev/null | \
  grep -E 'tigervncserver|vncserver'

dpkg -L tigervnc-tools 2>/dev/null | \
  grep -E 'tigervncpasswd|vncpasswd'

echo
echo "[4] ENLACES VNC"
ls -la /usr/bin/vncserver 2>&1
ls -la /usr/bin/vncpasswd 2>&1

echo
echo "[5] ALTERNATIVES"
ls -la /etc/alternatives/vncserver 2>&1
ls -la /etc/alternatives/vncpasswd 2>&1

echo
echo "[6] BASE ALTERNATIVES"
ls -la /var/lib/dpkg/alternatives/vncserver 2>&1
ls -la /var/lib/dpkg/alternatives/vncpasswd 2>&1

echo
echo "[7] PATH"
echo "$PATH"

echo
echo "===== FIN ====="
