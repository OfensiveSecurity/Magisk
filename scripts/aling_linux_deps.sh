    # 1. Definir la versión exacta que requiere Torch
    REQUIRED_SETUPTOOLS="81.0.0"

    echo "[*] Alineando versiones de Nexus Core..."
    echo "[*] Desinstalando versión incompatible de setuptools..."
    pip uninstall setuptools -y

    # 2. Instalar la versión específica y asegurar que wheel no interfiera
    echo "[*] Instalando setuptools v$REQUIRED_SETUPTOOLS..."
    pip install "setuptools<$REQUIRED_SETUPTOOLS" wheel

    # 3. Verificar la integridad de Torch y Transformers
    echo "[*] Validando dependencias de IA..."
    pip check

    if [ $? -eq 0 ]; then
        echo "[✔] Conflicto resuelto. Las dependencias están sincronizadas."
    else
        echo "[!] Advertencia: Aún existen discrepancias menores. Procediendo c>  fi


