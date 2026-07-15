#!/bin/bash
#!/bin/sh
''':'
exec python3 "$0" "$@"
# In /etc/pam.d/sshd
auth required pam_google_authenticator.so
'''
#!/bin/bash
# Define costs
COST_PINEAPPLE=50
COST_BANANA=4
COST_WATERMELON=23
COST_BASKET=1
def validar_entero(mensaje, minimo, maximo):
    while True:
        try:
            valor = int(input(mensaje))
            if minimo <= valor <= maximo:
                return valor
            print(f"Error: El número debe estar entre {minimo} y {maximo}.")
        except ValueError:
            print("Error: Por favor, introduce un número entero válido.")

print("¡Éxito! El script híbrido se está ejecutando correctamente en Python.")
echo {
   ...
   "models": [
   {
     "id": "<model-id>",
     "modelOptions": {
       "temperature": 1,
       "top_p": null
     },
     ...
   }
}
echo "--- 🛠️ INSTALADOR KALI TOOLS INTERFACE ---"

# 1. Actualizar repositorios e instalar dependencias base
sudo apt update
sudo apt install -y php-cli php-curl php-json openssh-server

# 2. Configurar SSH para permitir root (necesario para la interfaz)
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# 3. Crear el servicio de Systemd para que inicie en el boot
SERVICE_FILE="/etc/systemd/system/kali-interface.service"
WORKING_DIR=$(pwd)

sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Servidor PHP para Kali Tools Interface
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$WORKING_DIR
ExecStart=/usr/bin/php -S 0.0.0.0:8080
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 4. Recargar y activar servicio
sudo systemctl daemon-reload
sudo systemctl enable kali-interface.service
sudo systemctl start kali-interface.service

echo "--- ✅ INSTALACIÓN COMPLETADA ---"
echo "Accede en: http://localhost:8080"
