#!/bin/bash
# Pone la interfaz interna o externa en modo monitor de un solo golpe
echo "[*] Levantando interfaz wlan1..."
ifconfig wlan1 up
airmon-ng start wlan1
echo "[+] Modo monitor activo en wlan1mon"
airodump-ng wlan1mon
