#!/bin/bash

# Configuración de Rutas
LOG_DIR="/data/data/com.termux/files/home/nexus/logs"
REPORT_PATH="/data/data/com.termux/files/home/nexus/reports/WEEKLY_$(date +%Y_W%V).md"
REPO_PATH="/data/data/com.termux/files/home/nexus-system-v1.0"

echo "[*] Generando Auditoría Semanal NEXUS..."

# 1. Conteo de Incidentes
THERMAL_EVENTS=$(grep -c "ALERTA TÉRMICA" $LOG_DIR/thermal.log)
TRAFFIC_TRIGGERS=$(grep -c "PICO DETECTADO" $LOG_DIR/trigger.log)
CLEAN_ACTIONS=$(grep -c "CLEAN_SUCCESS" $LOG_DIR/offload.log)

# 2. Construcción del Reporte (Markdown)
cat <<EOF > $REPORT_PATH
# 📊 NEXUS CORE v3.0 - REPORTE SEMANAL
**Periodo:** $(date -d "7 days ago" +%d/%m/%Y) al $(date +%d/%m/%Y)
**Dispositivo:** Moto E13 (Unisoc T606)

---

## 🛡️ Seguridad y Hardware
* **Alertas Térmicas (>45°C):** $THERMAL_EVENTS incidentes.
* **Activaciones de Kill-Switch:** $(grep -c "SHUTDOWN" $LOG_DIR/thermal.log) eventos.

## 📡 Actividad de Red (PEN-200 Labs)
* **Picos de Tráfico Detectados:** $TRAFFIC_TRIGGERS eventos registrados.
* **Pico Máximo de PPS:** $(grep "pps" $LOG_DIR/trigger.log | awk '{print $4}' | sort -nr | head -n1) pps.

## 💾 Gestión de Almacenamiento
* **Limpiezas Automáticas:** $CLEAN_ACTIONS ejecuciones.
* **Espacio Actual:** $(df -h / | awk 'NR==2 {print $4}') disponible.

---
*Reporte generado automáticamente por NEXUS SYSTEM v1.0*
EOF

# 3. Sincronización Final
cp $REPORT_PATH $REPO_PATH/reports/
cd $REPO_PATH
git add reports/*.md
git commit -m "AUDIT: Reporte semanal generado [$(date +%W)]"
git push origin logs-moto-e13 -q

echo "[✓] Reporte enviado a GitHub y guardado localmente."
