#!/system/bin/sh
# Nexus Compatibility Kernel Script

# 1. Habilitar Forwarding de IP (Necesario para ataques Man-in-the-Middle)
echo 1 > /proc/sys/net/ipv4/ip_forward

# 2. Optimizar el soporte para la GPU (Adreno/Mali)
setprop debug.cpurend.hw 1
setprop persist.sys.ui_hw 1

# 3. Intentar cargar módulos de WiFi externos (si existen)
insmod /vendor/lib/modules/wlan.ko
insmod /vendor/lib/modules/cfg80211.ko

# 4. Eliminar restricciones de permisos de red para apps
chmod 666 /dev/bus/usb/*
