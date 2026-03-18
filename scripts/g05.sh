#!/bin/bash

# Colores tácticos
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

clear
echo -e "${BLUE}==========================================${NC}"
echo -e "${BLUE}    CENTINELA G05 - PANEL OPERATIVO      ${NC}"
echo -e "${BLUE}==========================================${NC}"
echo -e " Dispositivo: Moto G05 | Kernel: Custom-NH"
echo -e " Estado: $([[ $EUID -ne 0 ]] && echo -e "${RED}SIN ROOT${NC}" || echo -e "${GREEN}ROOT ACTIVO${NC}")"
echo "------------------------------------------"

menu_principal() {
    echo -e "1.  ${GREEN}[VAULT]${NC} Montar Bóveda Cifrada"
    echo -e "2.  ${GREEN}[NET]${NC}   Modo Monitor (wlan1)"
    echo -e "3.  ${GREEN}[SRV]${NC}   Iniciar Servidor Audit G05"
    echo -e "4.  ${GREEN}[HID]${NC}   Lanzar Ataque HID (BadUSB)"
    echo -e "5.  ${RED}[CLEAN]${NC} Limpieza OPSEC (Logs/Tmp)"
    echo -e "6.  Salir"
    echo "------------------------------------------"
    read -p "Seleccione una opción: " opt

    case $opt in
        1)
            echo "[*] Abriendo contenedor LUKS..."
            cryptsetup open /data/local/nh_data.img vault && \
            mount /dev/mapper/vault /root/archivos_sensibles
            echo "[+] Bóveda montada en /root/archivos_sensibles"
            ;;
        2)
            echo "[*] Configurando wlan1 en modo monitor..."
            ip link set wlan1 down
            iw dev wlan1 set type monitor
            ip link set wlan1 up
            echo "[+] Interfaz lista. Iniciando airodump..."
            airodump-ng wlan1
            ;;
        3)
            echo "[*] Iniciando servidor OMNI-Stealth..."
            cd ~/G05_Labs && ./audit_g05
            ;;
        4)
            echo "[*] Configurando interfaz HID..."
            # Script de activación de teclado USB para NetHunter
            setprop sys.usb.config hid
            echo "[+] Dispositivo reconocido como teclado. Listo para payloads."
            ;;
        5)
            echo -e "${RED}[!] Ejecutando limpieza profunda...${NC}"
            rm -rf ~/.bash_history
            rm -rf /data/local/tmp/*
            history -c
            echo "[+] Huellas eliminadas."
            ;;
        6) exit 0 ;;
        *) echo "Opción no válida."; sleep 1; menu_principal ;;
    esac
}

menu_principal
