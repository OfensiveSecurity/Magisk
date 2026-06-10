#!/bin/bash
echo "[*] Iniciando limpieza de repositorios conflictivos..."

# 1. Definir rutas de Termux y Proot
PATHS=(
    "/data/data/com.termux/files/usr/etc/apt/sources.list.d"
    "/etc/apt/sources.list.d"
)

# 2. Vaciar archivos en lugar de borrarlos (más seguro si rm falla)
for dir in "${PATHS[@]}"; do
    if [ -d "$dir" ]; then
        echo "[+] Limpiando en $dir..."
        for file in "$dir"/parrot.list "$dir"/kali.list; do
            if [ -f "$file" ]; then
                > "$file" # Esto vacía el archivo sin usar binarios externos
                echo "    [-] $file neutralizado."
            fi
        done
    fi
done

# 3. Intentar corregir el estado de dpkg
echo "[*] Intentando recuperar dpkg..."
export LD_PRELOAD="" # Limpiamos posibles librerías corruptas en memoria
apt-get update -o Dir::Etc::sourcelist="sources.list" -o Dir::Etc::sourceparts="-" 
