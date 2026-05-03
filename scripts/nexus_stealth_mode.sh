#!/bin/bash

# 1. Notificación Silenciosa al Dashboard
echo "STEALTH_MODE_ACTIVE" > ~/nexus/logs/system_status.tmp

# 2. Apagar Brillo al 0% (Simula pantalla apagada)
# Algunos Moto E13 usan /sys/class/backlight/
su -c "settings put system screen_brightness 0"
su -c "settings put system screen_brightness_mode 0"

# 3. Desactivar el Touch (Bloqueo de Interacción)
# Esto evita que un roce accidental cancele el ataque HID
su -c "wm disable-user-input"

# 4. Alerta de Hardware (Solo para el operador)
# Una vibración corta para confirmar que el modo sigilo inició
termux-vibrate -d 100

echo "[✓] MODO SIGILO: Pantalla y Touch bloqueados. Iniciando HID..."
