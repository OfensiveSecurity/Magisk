#!/bin/bash
# 1. Crear un archivo de 2GB lleno de ceros
dd if=/dev/zero of=/root/kali_vault.img bs=1M count=2048

# 2. Configurar el dispositivo de bucle con LUKS
# TE PEDIRÁ UNA CONTRASEÑA MAESTRA AQUÍ
sudo cryptsetup luksFormat /root/kali_vault.img

# 3. Abrir la bovéda
sudo cryptsetup open /root/kali_vault.img vault_data

# 4. Formatear el interior en EXT4
sudo mkfs.ext4 /dev/mapper/vault_data

# 5. Montarlo en tu carpeta de la interfaz
mkdir -p /root/kali-web-interface/output
sudo mount /dev/mapper/vault_data /root/kali-web-interface/output
