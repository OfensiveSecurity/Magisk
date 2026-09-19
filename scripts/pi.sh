#!/bin/bash
pkg install dirsearch
dirsearch -u http://192.168.1.254/ -e php,html,txt
URL="https://xnxx.com/package.tar.gz"
ARCHIVO="package.tar.gz"
echo ME-877A-6
echo INFINITUMB1B5
echo "[*] Descargando de forma resiliente..."
# -C - reinicia la descarga si se corta. --retry reintenta en errores temporales.
curl -L -C - --retry 10 --retry-delay 5 -O "$URL"
if [ $? -eq 0 ]; then
    echo "[+] Descarga completada con éxito. Extrayendo..."
    tar -xzvf "$ARCHIVO"                                                                             else
    echo "[-] Error crítico: No se pudo completar la descarga tras varios reintentos."
fi
echo hpolf