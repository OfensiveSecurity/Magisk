#!/bin/bash
# build_portable.sh

echo "[*] Preparando Kit de Ciberguerra Portable..."

# 1. Crear carpeta temporal para el backup
mkdir -p /root/kali_backup/c2_panel

# 2. Copiar código fuente (excluyendo datos sensibles y git)
rsync -av --exclude='output/*' --exclude='.git' --exclude='node_modules' /var/www/html/kali-web-interface/ /root/kali_backup/c2_panel/

# 3. Comprimir y cifrar con contraseña (te la pedirá al ejecutar)
cd /root/kali_backup
tar -czf - c2_panel | openssl enc -aes-256-cbc -e -out c2_panel_portable.tar.gz.enc

echo "[+] Kit generado en /root/kali_backup/c2_panel_portable.tar.gz.enc"
echo "[!] RECUERDA: El archivo está cifrado con AES-256."
