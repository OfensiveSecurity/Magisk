#!/bin/bash

echo "[*] Corrigiendo falta de typing_extensions en el entorno..."

# 1. Forzar variables de compatibilidad
export UV_LINK_MODE=copy
export PWNDBG_NO_AUTOUPDATE=1

# 2. Entrar al directorio del proyecto
cd /root/pwndbg || exit

# 3. Instalar manualmente la dependencia faltante usando el instalador de uv
# Forzamos el modo copia para evitar el "os error 1"
echo "[*] Instalando typing_extensions y dependencias base..."
uv pip install --link-mode copy --active typing_extensions

# 4. Verificar si faltan otras dependencias comunes que causan el mismo crash
uv pip install --link-mode copy --active setuptools six

echo "[+] Dependencias críticas instaladas."
echo "[*] Intentando iniciar GDB..."
gdb -q -ex "quit" && echo "[!] GDB cargó Pwndbg exitosamente" || echo "[?] Si sigue fallando>




