#!/bin/bash
# NEXUS CLOUD SYNC v1.0

SOURCE_DIR="~/nexus/loot/"
REMOTE_SERVER="tu_servidor_seguro.com"
TIMESTAMP=$(date +%Y%m%d_%H%M)

echo "[*] INICIANDO RESPALDO CIFRADO EN LA NUBE..."

# 1. Empacar y cifrar el Loot del PEN-200
tar -czf - $SOURCE_DIR | gpg -c --batch --passphrase "TU_LLAVE_MAESTRA" > ~/nexus/backups/loot_$TIMESTAMP.tar.gz.gpg

# 2. Subida silenciosa al servidor (Shadow-Transfer)
scp -P 2222 ~/nexus/backups/loot_$TIMESTAMP.tar.gz.gpg user@$REMOTE_SERVER:/home/user/nexus_vault/

# 3. Limpieza local del backup temporal
rm ~/nexus/backups/*.gpg

echo "[✓] EXFILTRACIÓN EXITOSA: Evidencia resguardada en la Fortaleza."
