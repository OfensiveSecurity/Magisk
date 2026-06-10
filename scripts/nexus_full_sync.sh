#!/bin/bash

# Configuración
REPO_PATH="/data/data/com.termux/files/home/nexus-system-v1.0"
CRYPTO_LOG="$REPO_PATH/backups/market_data_$(date +%Y%m%d).json"
DATE=$(date +'%Y-%m-%d_%H%M')

# 1. Captura de Precios Binance (BTC, ETH, BNB)
echo "[*] Capturando datos de Binance..."
curl -s "https://api.binance.com/api/v3/ticker/price?symbols=[\"BTCUSDT\",\"ETHUSDT\",\"BNBUSDT\"]" \
     -o "$CRYPTO_LOG"

# 2. Consolidar con el resumen de logs del NEXUS CORE
tail -n 300 "/data/data/com.termux/files/home/nexus/logs/nexus_core.log" >> "$REPO_PATH/backups/summary_$DATE.log"

# 3. Sincronización con GitHub
cd "$REPO_PATH"
git add backups/market_data_*.json backups/summary_$DATE.log
git commit -m "NEXUS_AUTO_SYNC: Logs + Market Data [$DATE]"
git push origin logs-moto-e13 -q

# 4. Notificación al Dashboard
curl -X POST "http://127.0.0.1:8080/api/notifications" \
     -H "Content-Type: application/json" \
     -d "{\"event\": \"MARKET_BACKUP\", \"status\": \"SUCCESS\", \"btc_snapshot\": \"$(date)\"}"
