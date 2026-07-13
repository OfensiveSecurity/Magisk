#!/bin/bash
# 1. Definir rutas
PWNDBG_DIR="/root/pwndbg"
VENV_PATH="$PWNDBG_DIR/.venv"
echo "[*] Sincronizando dependencias con modo copia forzado..."
export UV_LINK_MODE=copy                                                                cd $PWNDBG_DIR
uv pip install --link-mode copy typing_extensions --active
# 2. Obtener la ruta exacta de site-packages dentro del venv
SITE_PACKAGES=$(find $VENV_PATH -name "site-packages" -type d | head -n 1)
if [ -z "$SITE_PACKAGES" ]; then
    echo "[!] Error: No se encontró la carpeta site-packages en $VENV_PATH"                 exit 1
fi
echo "[*] Inyectando ruta en .gdbinit: $SITE_PACKAGES"
# 3. Crear un .gdbinit que configure el PATH antes de cargar pwndbg
cat << EOGDB > ~/.gdbinit
python
import sys
import os
sys.path.insert(0, '$SITE_PACKAGES')
end
source $PWNDBG_DIR/gdbinit.py
EOGDB
echo "[+] Hecho. Ahora el Python interno de GDB buscará en el entorno virtual."
echo "[*] Prueba ejecutando: gdb -q"