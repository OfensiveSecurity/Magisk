#!/bin/bash

# 1. Definir rutas absolutas
PWNDBG_DIR="/root/pwndbg"
VENV_PYTHON="$PWNDBG_DIR/.venv/bin/python"

echo "[*] Limpiando procesos y configurando modo copia..."
export UV_LINK_MODE=copy

# 2. Instalar dependencias usando el python del venv directamente
# Esto evita usar '--active' y asegura que se instale en el lugar correcto
if [ -f "$VENV_PYTHON" ]; then
    echo "[*] Instalando dependencias en el entorno virtual de Nexus..."
    $VENV_PYTHON -m pip install --no-cache-dir typing_extensions setuptools six
else
    echo "[!] No se encontró el venv en $VENV_PYTHON. Intentando con uv estándar..."
    uv pip install --link-mode copy typing_extensions
fi

# 3. Localizar site-packages de forma dinámica
SITE_PACKAGES=$($VENV_PYTHON -c "import site; print(site.getsitepackages()[0])" 2>/dev/null)

if [ -z "$SITE_PACKAGES" ]; then
    SITE_PACKAGES=$(find /root/pwndbg/.venv -name "site-packages" -type d | head -n 1)
fi

echo "[*] Ruta detectada: $SITE_PACKAGES"

# 4. Re-escribir el .gdbinit con la ruta inyectada
cat << EOGDB > ~/.gdbinit
python
import sys
import os
# Inyectamos el path del venv al principio para que GDB lo priorice
sys.path.insert(0, '$SITE_PACKAGES')
end
source /root/pwndbg/gdbinit.py
EOGDB

echo "[+] Configuración terminada. Ejecuta 'gdb -q' para probar."
