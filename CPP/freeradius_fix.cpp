#include <iostream>
#include <cstdlib>
#include <string>

int main() {
    std::cout << "[*] Iniciando limpieza de FreeRADIUS para Nexus..." << std::endl;

    // 1. Matar procesos en el puerto 1812 (UDP/TCP)
    std::cout << "[!] Liberando puerto 1812..." << std::endl;
    system("sudo fuser -k 1812/udp > /dev/null 2>&1");
    system("sudo fuser -k 1812/tcp > /dev/null 2>&1");

    // 2. Comentar la línea de dh_file que causa el warning de TLS
    std::cout << "[!] Optimizando configuración TLS..." << std::endl;
    system("sudo sed -i 's/^\\s*dh_file =/# dh_file =/' /etc/freeradius/3.0/mods-enabled/eap");

    // 3. Verificar permisos de log
    system("sudo chown -R freerad:freerad /var/log/freeradius");

    std::cout << "[+] Puerto liberado y configuración saneada." << std::endl;
    std::cout << "[*] Lanzando FreeRADIUS en modo debug (X)..." << std::endl;

    // 4. Ejecutar FreeRADIUS
    system("sudo freeradius -X");

    return 0;
}