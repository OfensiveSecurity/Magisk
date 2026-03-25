#!/bin/bash
# NEXUS-LOOT-LOGGER v1.0

LOOT_FILE="~/nexus/logs/loot_captured.txt"

# Monitorear archivos de resultados en tiempo real
tail -f ~/nexus/logs/*.txt | grep --line-buffered -E "user:|pass:|password:|login:|admin:|token:" | while read -r line; do
    # 1. Limpiar la línea y añadir timestamp
    CLEAN_LOOT=$(echo "$line" | sed 's/^[ \t]*//')
    TIME=$(date +"%H:%M")
    
    # 2. Guardar en el log central
    echo "[$TIME] $CLEAN_LOOT" >> $LOOT_FILE
    
    # 3. Notificar al Dashboard
    curl -s -X POST -d "data=[$TIME] $CLEAN_LOOT" http://localhost:8080/update_loot
done
