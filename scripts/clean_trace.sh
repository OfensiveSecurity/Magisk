#!/bin/bash

echo "[!] INICIANDO PROTOCOLO DE LIMPIEZA DE RASTROS..."

# 1. Limpiar el historial de la sesión actual de Bash
history -c

# 2. Sobrescribir y eliminar el archivo físico del historial
if [ -f ~/.bash_history ]; then
    shred -u -z -n 3 ~/.bash_history
    touch ~/.bash_history
fi

# 3. Limpiar logs temporales del servidor PHP si existen
if [ -d "logs" ]; then
    rm -rf logs/*.log
fi

# 4. Vaciar la papelera (opcional pero recomendado)
rm -rf ~/.local/share/Trash/*

echo "[+] RASTROS ELIMINADOS. LA SESIÓN ES AHORA INVISIBLE."
