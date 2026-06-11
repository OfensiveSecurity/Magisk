#!/bin/bash
# PROTOCOLO DE AUTODESTRUCCIÓN DE EVIDENCIAS
# Si el teléfono no se conecta a tu IP de confianza en 24h, borra los datos sensibles.

TRUSTED_IP="TU_IP_DE_CASA"
CHECK=$(ping -c 1 $TRUSTED_IP | grep "received" | awk '{print $4}')

if [ "$CHECK" != "1" ]; then
    echo "[!] ALERTA: Dispositivo fuera de zona segura."
    # Simulación de borrado de carpetas tácticas
    # rm -rf ~/nexus/tactical_payloads/
    # rm -rf ~/nexus/logs/
    echo "[X] Datos tácticos eliminados para proteger al operador."
fi
