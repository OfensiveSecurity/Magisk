#!/bin/bash

EXPECTED_COUNTRY="Mexico"
LOG_FILE="/data/data/com.termux/files/home/nexus/logs/network_security.log"

check_and_lock() {
    # 1. Obtener País por IP
    CURRENT_COUNTRY=$(curl -s --max-time 5 https://ipapi.co/country_name/)
    
    if [ "$CURRENT_COUNTRY" != "$EXPECTED_COUNTRY" ] && [ ! -z "$CURRENT_COUNTRY" ]; then
        echo "[!] VIOLACIÓN GEOGRÁFICA: IP detectada en $CURRENT_COUNTRY" >> $LOG_FILE
        
        # 2. Alerta Táctica (Hardware)
        termux-vibrate -d 2000
        termux-tts-speak "Alerta de seguridad. IP extranjera detectada. Cortando datos móviles ahora."

        # 3. KILL-SWITCH de Red (Requiere Root/Magisk)
        # Apaga datos móviles y pone modo avión para purgar la IP
        su -c "settings put global airplane_mode_on 1"
        su -c "am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true"
        
        echo "[X] RED CORTADA: $(date)" >> $LOG_FILE
        return 1
    fi
}

check_and_lock
