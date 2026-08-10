#!/bin/bash

# 1. Localizar UV y Python del VENV
# Buscamos uv en local bin por si no está en el PATH global
UV_BIN=$(which uv || echo "/root/.cargo/bin/uv" || echo "/usr/local/bin/uv")
PWNDBG_DIR="/root/pwndbg"
VENV_PYTHON="$PWNDBG_DIR/.venv/bin/python"

echo "[*] Usando UV en: $UV_BIN"
echo "[*] Usando Python en: $VENV_PYTHON"

# 2. Forzar instalación de dependencias sin usar el PATH
# Usamos --link-mode copy para evitar el error de hardlinks (os error 1)
export UV_LINK_MODE=copy
export PWNDBG_NO_AUTOUPDATE=1

if [ -f "$UV_BIN" ]; then
    echo "[*] Instalando typing_extensions con UV..."
    $UV_BIN pip install --link-mode copy --python "$VENV_PYTHON" typing_extensions setuptools
else
    echo "[!] UV no encontrado, intentando con el pip interno del venv..."
    $VENV_PYTHON -m pip install --no-cache-dir typing_extensions setuptools
fi

# 3. Identificar la ruta de librerías para GDB
SITE_PACKAGES=$($VENV_PYTHON -c "import site; print(site.getsitepackages()[0])" 2>/dev/null)

# 4. Configurar .gdbinit de forma persistente y limpia
echo "[*] Generando archivo .gdbinit..."
cat << EOGDB > ~/.gdbinit
python
import sys
import os

# Definir la ruta de las librerías del entorno virtual
site_pkgs = '$SITE_PACKAGES'

if os.path.exists(site_pkgs):
    sys.path.insert(0, site_pkgs)

# Evitar que pwndbg intente actualizarse y falle por el PATH de uv
os.environ["PWNDBG_NO_AUTOUPDATE"] = "1"
end

source /root/pwndbg/gdbinit.py
EOGDB

echo "[+] Nexus GDB Fix aplicado."
echo "[*] Ejecuta: gdb -q"
