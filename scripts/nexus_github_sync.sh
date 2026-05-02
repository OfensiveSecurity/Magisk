#!/bin/bash

# Configuración de Repositorio
REPO_PATH="/data/data/com.termux/files/home/nexus-system-v1.0"
LOG_SOURCE="/data/data/com.termux/files/home/nexus/logs"
DATE=$(date +'%Y-%m-%d_%H%M')
BRANCH="logs-moto-e13"

cd "$REPO_PATH"

# 1. Preparar el resumen de logs (últimas 500 líneas de eventos críticos)
tail -n 500 "$LOG_SOURCE/nexus_core.log" > "$REPO_PATH/backups/summary_$DATE.log"

# 2. Agregar cambios al índice
git add backups/summary_$DATE.log
git commit -m "NEXUS_SYNC: Resumen de logs generado el $DATE [Moto E13]"

# 3. Empujar a GitHub (silenciosamente)
git push origin $BRANCH -q

# 4. Notificar al Dashboard
curl -X POST "http://127.0.0.1:8080/api/notifications" \
     -H "Content-Type: application/json" \
     -d "{\"event\": \"GITHUB_SYNC\", \"status\": \"SUCCESS\", \"file\": \"summary_$DATE.log\"}"
