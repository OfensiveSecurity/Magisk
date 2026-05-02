#!/bin/bash
# NEXUS-SAFE: BLOQUEO DE PUERTO DE DATOS

function lock_usb() {
    # Desactiva ADB y MTP (Transferencia de archivos)
    su -c "settings put global adb_enabled 0"
    su -c "setprop sys.usb.config none"
    su -c "setprop sys.usb.state none"
    echo "[!] PUERTO USB BLOQUEADO: Solo carga eléctrica permitida."
}

function unlock_usb() {
    # Reactiva para el operador legítimo
    su -c "settings put global adb_enabled 1"
    su -c "setprop sys.usb.config mtp,adb"
    echo "[✓] PUERTO USB LIBERADO: Acceso de datos activo."
}

# Ejecutar bloqueo al inicio (Boot)
lock_usb
