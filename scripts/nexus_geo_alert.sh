#!/bin/bash

# Configuración: País esperado
EXPECTED_COUNTRY="Mexico"

check_geo() {
    # 1. Obtener ubicación actual de la IP
    CURRENT_COUNTRY=$(curl -s https://ipapi.co/country_name/)
    
    if [ "$CURRENT_COUNTRY" != "$EXPECTED_COUNTRY" ] && [ ! -z "$CURRENT_COUNTRY" ]; then
        echo -e "\e[1;31m[!] ALERTA GEOGRÁFICA: Navegando desde $CURRENT_COUNTRY\e[0m"
        
        # 2. Feedback de Hardware (Moto E13)
        # Vibra por 500ms
        termux-vibrate -d 500
        # Pitido de alerta
        termux-tts-speak "Alerta. Tráfico fuera de México detectado. Posible bloqueo en S A T."
        
        return 1
    else
        echo -e "\e[1;32m[✓] GEO-FENCE: Localización correcta ($EXPECTED_COUNTRY).\e[0m"
        return 0
    fi
}

# Ejecución única
check_geo
