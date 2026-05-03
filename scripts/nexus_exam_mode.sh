#!/bin/bash

# --- PERFIL DE ALTO RENDIMIENTO (EXAMEN) ---
NEW_TEMP_LIMIT=48000  # Elevado a 48°C (Margen de maniobra extra)
NEW_THRESHOLD=1500    # Elevado a 1500 pps (Para escaneos intensos)

echo -e "\e[1;31m[!] ACTIVANDO MODO EXAM-READY (PEN-200)...\e[0m"

# 1. Aplicar nuevos umbrales a los procesos activos
# (Modifica las variables en caliente para los scripts que ya están corriendo)
pkill -f nexus_thermal_guard.sh
pkill -f nexus_traffic_trigger_v2.sh

# 2. Reiniciar servicios con configuración de examen
nohup /bin/bash /ruta/al/script/nexus_thermal_guard.sh --limit $NEW_TEMP_LIMIT &
nohup /bin/bash /ruta/al/script/nexus_traffic_trigger_v2.sh --threshold $NEW_THRESHOLD &

# 3. Optimización de Memoria (Limpiar buffers antes de empezar)
sync && echo 3 > /proc/sys/vm/drop_caches

echo -e "\e[1;32m[✓] SISTEMA OPTIMIZADO PARA CERTIFICACIÓN.\e[0m"
echo "[i] Los límites térmicos se han relajado. Monitorea el calor manualmente."
