    # Definición de rutas y exportación de PATH para Root
    export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    VENV_PATH="/root/path/to/venv"

    if [ -d "$VENV_PATH" ]; then
        source "$VENV_PATH/bin/activate"
        echo "[*] Entorno Virtual Activado: $VENV_PATH"

        # Instalación compuesta de dependencias para llama.cpp
        echo "[*] Verificando dependencias de IA (Torch/Transformers)..."
        pip install --quiet torch transformers huggingface_hub pyyaml

        if [ $? -eq 0 ]; then
            echo "[✔] Sistema linux listo para convert_hf_to_gguf.py"
        else
            echo "[!] Error durante la instalación de dependencias."
        fi
    else
        echo "[!] Error Crítico: El directorio del entorno no existe."            fi

