#!/bin/bash

# Rutas de seguridad
DOWNLOAD_DIR="$HOME/Magisk_Reciente"
BOOT_BACKUP="$HOME/boot_backup.img"

echo "[*] Iniciando proceso de flasheo seguro..."

# 1. Verificar si tenemos el APK
if [ ! -f "$DOWNLOAD_DIR/magisk.apk" ]; then
    echo "[!] Error: No se encontró el APK. Ejecuta 'actualizar_magisk' primero."
    exit 1
fi

# 2. Extraer el binario magiskboot (C++ Nativo)
unzip -j "$DOWNLOAD_DIR/magisk.apk" "lib/x86_64/libmagiskboot.so" -d "$DOWNLOAD_DIR"
mv "$DOWNLOAD_DIR/libmagiskboot.so" "$DOWNLOAD_DIR/magiskboot"
chmod +x "$DOWNLOAD_DIR/magiskboot"

# 3. Dump del boot actual (Requiere Root)
echo "[*] Extrayendo partición boot..."
su -c "dd if=/dev/block/by-name/boot of=$BOOT_BACKUP"

# 4. Parchear con el nuevo Magisk
cd "$DOWNLOAD_DIR"
./magiskboot unpack "$BOOT_BACKUP"
./magiskboot patch
# (Aquí Magisk genera un 'new-boot.img')

# 5. Flashear el nuevo kernel
echo "[!] ATENCIÓN: Flasheando nuevo kernel..."
su -c "dd if=new-boot.img of=/dev/block/by-name/boot"

echo "[SUCCESS] Magisk actualizado y flasheado. Reinicia para aplicar."
