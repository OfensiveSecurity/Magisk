#!/bin/bash
# telegram_backup.sh

TOKEN="TU_TOKEN_DE_TELEGRAM"
CHAT_ID="TU_CHAT_ID"
BACKUP_NAME="/tmp/kali_c2_backup_$(date +%F).tar.gz"

echo "[*] Comprimiendo el panel..."
# Comprimir excluyendo la bóveda (output) y git
tar -czf $BACKUP_NAME -C /var/www/html/kali-web-interface/ . --exclude='./output' --exclude='./.git'

echo "[*] Enviando a Telegram..."
curl -F document=@"$BACKUP_NAME" \
     "https://api.telegram.org/bot$TOKEN/sendDocument?chat_id=$CHAT_ID&caption=📦 Backup Semanal de Kali-Panel (Ready for Deploy)"

# Limpiar el archivo temporal
rm $BACKUP_NAME
echo "[+] Backup enviado con éxito."
