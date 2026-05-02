#!/bin/bash
# linux CORE - MASTER CONTROL v3.3

show_menu() {
    clear
    echo "=========================================="
    echo "      linux CORE SYSTEM v3.3 (OSCP)       "
    echo "=========================================="
    echo "[1] Levantar Base de Datos (MariaDB)"
    echo "[2] Iniciar Reconocimiento (Nexus-Recon)"
    echo "[3] Lanzar Fuzzer CAN (Logging to DB)"
    echo "[4] ACTIVAR WI-FI CORPORATIVO (RADIUS)"
    echo "[5] Ver quién está conectado (Logs)"
    echo "[6] Detener todos los servicios"
    echo "[7] Salir"
    echo "=========================================="
}

while true; do
    show_menu
    read -p "Linux > " opt
    case $opt in
        1) sudo service mariadb start && echo "[+] DB Online" ;;
        2) python3 ~/Nexus-Suite/tools/nexus-recon.py ;;
        3) python3 ~/Nexus-Suite/tools/canfuzzer.py ;;
        4) sudo service freeradius restart && echo "[+] RADIUS Online en .79">
        5) sudo tail -f /var/log/freeradius/radius.log ;;
        6) sudo service freeradius stop && sudo service mariadb stop && echo >
        7) exit 0 ;;
        *) echo "Opción no válida." ; sleep 1 ;;
    esac
    read -p "Presiona Enter para continuar..."
done
