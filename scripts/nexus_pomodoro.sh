#!/bin/bash
# NEXUS POMODORO v1.0 - BLOQUEO DE HOSTS

DURATION=25 # Minutos de enfoque
BREAK=5     # Minutos de descanso

function lock_distractions() {
    echo "[!] BLOQUEANDO DISTRACCIONES (Facebook, Instagram, TikTok, etc.)"
    # Modificamos el archivo hosts de Android vía Magisk
    su -c "echo '127.0.0.1 facebook.com' >> /system/etc/hosts"
    su -c "echo '127.0.0.1 instagram.com' >> /system/etc/hosts"
    su -c "echo '127.0.0.1 tiktok.com' >> /system/etc/hosts"
    # Notificar al Dashboard de la laptop para que bloquee vía extensión/hosts
    curl -s -X POST -d "status=FOCUS_ON" http://localhost:8080/sync_focus
}

function unlock_distractions() {
    echo "[✓] SESIÓN COMPLETADA. TIEMPO DE DESCANSO."
    su -c "sed -i '/facebook.com\|instagram.com\|tiktok.com/d' /system/etc/hosts"
    termux-tts-speak "Sesión terminada. Toma un descanso de 5 minutos, Operador."
}

# Iniciar Ciclo
lock_distractions
sleep $((DURATION * 60))
unlock_distractions
