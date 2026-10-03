#!/bin/bash

echo "===== VNC TARGETS ====="

echo
echo "[1] Enlaces actuales"
ls -l /usr/bin/vncserver /usr/bin/vncpasswd 2>&1

echo
echo "[2] Destinos reales"
ls -l /usr/bin/tigervncserver /usr/bin/tigervncpasswd 2>&1

echo
echo "[3] Resolución"
readlink /usr/bin/vncserver 2>&1
readlink /usr/bin/vncpasswd 2>&1

echo
echo "[4] Resolución final"
readlink -f /usr/bin/vncserver 2>&1
readlink -f /usr/bin/vncpasswd 2>&1

echo
echo "[5] Alternatives"
ls -la /etc/alternatives/vncserver 2>&1
ls -la /etc/alternatives/vncpasswd 2>&1

echo
echo "[6] Base alternatives"
ls -la /var/lib/dpkg/alternatives/vncserver 2>&1
ls -la /var/lib/dpkg/alternatives/vncpasswd 2>&1

echo
echo "===== FIN ====="
