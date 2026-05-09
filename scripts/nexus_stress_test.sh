#!/bin/bash

echo -e "\e[1;33m[!] INICIANDO STRESS TEST DE 5 MINUTOS...\e[0m"
echo "[i] Objetivo: Validar estabilidad del Moto E13 en Modo Examen."

# 1. Activar Modo Examen para usar los nuevos umbrales
source ~/.bashrc
nexus-exam-on

# 2. Generar Carga de CPU (Cálculo de Pi en segundo plano)
echo "[*] Estresando CPU..."
for i in {1..4}; do
    python3 -c "while True: 22/7" &
done
STRESS_PIDS=$!

# 3. Generar Tráfico de Red Simulado (Ping Flood a localhost)
echo "[*] Generando tráfico de red..."
sudo ping -f -s 1000 127.0.0.1 &
PING_PID=$!

# 4. Monitoreo en Tiempo Real
echo -e "\n\e[1;37mObserva cómo sube la temperatura en 'nexus-status'...\e[0m"
for i in {1..30}; do
    nexus-status
    sleep 10
done

# 5. Limpieza
kill $STRESS_PIDS $PING_PID
echo -e "\n\e[1;32m[✓] STRESS TEST FINALIZADO. Revisa los logs en ~/nexus/logs/\e[0m"
