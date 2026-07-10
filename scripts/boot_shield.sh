#!/bin/bash

# 1. Esperar un poco a que el sistema y la red estén listos
sleep 10

# 2. Activar Wake Lock (Para que Android no duerma el proceso)
termux-wake-lock

# 3. Cargar reglas de Firewall (C++ Nativo de Magisk)
# Esto aplica tu lista negra de spam guardada
if [ -f "$HOME/antispam" ]; then
    su -c "$HOME/antispam --reload"
fi

# 4. Iniciar el Panel Web de Spam en segundo plano
# Usamos 'nohup' para que siga corriendo aunque cierres Termux
cd $HOME
nohup python spam_admin.py > /dev/null 2>&1 &

echo "[BOOT] Escudo Magisk y Panel Web ACTIVADOS."
