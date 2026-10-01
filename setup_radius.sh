#!/bin/bash
# Configuración limpia para el cliente Totalplay
echo "client totalplay_router {
    ipaddr = 192.168.100.1
    secret = 28710418jesus.
    require_message_authenticator = yes
    limit {
        max_connections = 16
        lifetime = 0
        idle_timeout = 30                                                                   }
}" | sudo tee /etc/freeradius/3.0/clients.conf
# Asegurar que el servidor escuche en todas las interfaces
sudo sed -i 's/ipaddr = 127.0.0.1/ipaddr = */' /etc/freeradius/3.0/sites-enabled/default
echo "[+] Configuración de clients.conf actualizada."
