#!/bin/bash

# --- CONFIGURACIÓN DE COLORES ---
VERDE='\033[0;32m'
AZUL='\033[0;34m'
ROJO='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${AZUL}=========================================="
echo -e "   🚀 INSTALADOR DE SUITE DE SEGURIDAD KALI"
echo -e "==========================================${NC}"

# 1. Verificar si es root
if [ "$EUID" -ne 0 ]; then 
  echo -e "${ROJO}[!] Por favor, ejecuta como root (sudo ./instalar_suite.sh)${NC}"
  exit
fi

# 2. Crear estructura de directorios
echo -e "\n${VERDE}[*] Creando estructura de carpetas...${NC}"
RUTA_BASE="/root/proyectos/limpieza"
mkdir -p $RUTA_BASE/{backups_seguridad,reportes_auditoria,logs}

# 3. Actualizar sistema e instalar dependencias base
echo -e "${VERDE}[*] Instalando dependencias del sistema...${NC}"
apt update && apt install -y python3 python3-pip python3-venv python3-2to3

# 4. Configurar Entorno Virtual (VENV)
echo -e "${VERDE}[*] Configurando entorno virtual de Python...${NC}"
python3 -m venv $RUTA_BASE/venv
source $RUTA_BASE/venv/bin/activate

# 5. Instalar librerías de Python
echo -e "${VERDE}[*] Instalando librerías necesarias (psutil)...${NC}"
pip install psutil

# 6. Crear el comando global (Alias)
echo -e "${VERDE}[*] Configurando acceso global 'limpiar'...${NC}"
BASH_RC="/root/.bashrc"
ALIAS_CMD="alias limpiar='source $RUTA_BASE/venv/bin/activate && python3 $RUTA_BASE/menu.py'"

if ! grep -q "alias limpiar=" "$BASH_RC"; then
    echo "$ALIAS_CMD" >> "$BASH_RC"
    echo -e "${VERDE}[+] Alias 'limpiar' añadido correctamente.${NC}"
else
    echo -e "${AZUL}[i] El alias 'limpiar' ya existe.${NC}"
fi

echo -e "\n${AZUL}=========================================="
echo -e "   ✅ INSTALACIÓN COMPLETADA CON ÉXITO"
echo -e "   Reinicia tu terminal o escribe: source ~/.bashrc"
echo -e "   Luego solo escribe: limpiar"
echo -e "==========================================${NC}"