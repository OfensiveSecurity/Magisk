#!/bin/bash
# 1. Asegurarnos de estar en la raíz de pwndbg
cd /root/pwndbg || exit
# 2. Si no existe el README.md, creamos uno vacío para que el script no falle
if [ ! -f "README.md" ]; then
    echo "[*] README.md no encontrado. Creando uno temporal..."
    echo "# Pwndbg - Nexus Research Environment" > README.md
fi
# 3. Corregir permisos y variables para evitar el error de actualización
export PWNDBG_NO_AUTOUPDATE=1
export UV_LINK_MODE=copy
# 4. Intentar ejecutar el script de generación desde la raíz, no desde /scripts
echo "[*] Ejecutando generador de documentación..."
python3 scripts/generate-readme.py 2>/dev/null || echo "[!] El script falló pero el README ya existe>echo "[+] Estructura de archivos saneada."
echo "[*] Ahora puedes iniciar gdb sin que el script de README te bloquee."