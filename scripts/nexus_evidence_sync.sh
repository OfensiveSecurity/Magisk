#!/bin/bash

# Configuración de Rutas
EVIDENCE_DIR="/data/data/com.termux/files/home/nexus/exam_evidence"
REPO_PATH="/data/data/com.termux/files/home/nexus-system-v1.0"
LOG_FILE="/data/data/com.termux/files/home/nexus/logs/evidence_sync.log"

# Crear carpeta si no existe
mkdir -p "$EVIDENCE_DIR"

echo "[*] NEXUS EVIDENCE: Iniciando sincronización de respaldo..."

# 1. Copiar evidencias nuevas al repositorio local
cp -r "$EVIDENCE_DIR/"* "$REPO_PATH/evidence/" 2>/dev/null

# 2. Sincronizar con GitHub
cd "$REPO_PATH"
git add evidence/*
# Commit con timestamp para trazabilidad forense
git commit -m "EXAM_EVIDENCE_BACKUP: $(date +'%H:%M:%S')" --quiet

# 3. Push silencioso
if git push origin logs-moto-e13 -q; then
    echo "[✓] Respaldo exitoso: $(date)" >> $LOG_FILE
    # Notificación rápida al dashboard
    curl -s -X POST "http://127.0.0.1:8080/api/notifications" \
         -H "Content-Type: application/json" \
         -d "{\"event\": \"EVIDENCE_SYNC\", \"status\": \"SUCCESS\"}"
else
    echo "[!] ERROR de sincronización: Revisa conexión." >> $LOG_FILE
fi
