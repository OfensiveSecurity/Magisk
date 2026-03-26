#!/bin/bash

echo "=== INSTALADOR DEL GESTOR DE LIMPIEZA KALI ==="

# 1. Crear directorios necesarios
echo "[*] Configurando carpetas..."
mkdir -p ~/proyectos/limpieza
cp *.py ~/proyectos/limpieza/

# 2. Configurar el Entorno Virtual
echo "[*] Creando entorno virtual de Python..."
python3 -m venv ~/proyectos/limpieza/venv
source ~/proyectos/limpieza/venv/bin/activate

# 3. Instalar dependencias
echo "[*] Instalando librerías necesarias..."
pip install requests

# 4. Inicializar Base de Datos
echo "[*] Configurando base de datos inicial..."
python3 -c "import seguridad_db; seguridad_db.inicializar_db()"

# 5. Crear el comando global (Alias)
echo "[*] Creando acceso directo 'limpiar'..."
if ! grep -q "alias limpiar=" ~/.zshrc; then
    echo "alias limpiar='~/proyectos/limpieza/venv/bin/python3 ~/proyectos/limpieza/menu.py'" >> ~/.zshrc
    echo "[+] Alias añadido a .zshrc"
fi

echo "============================================"
echo "¡INSTALACIÓN COMPLETADA!"
echo "Reinicia tu terminal o escribe: source ~/.zshrc"
echo "Luego solo escribe 'limpiar' para comenzar."
echo "============================================"
