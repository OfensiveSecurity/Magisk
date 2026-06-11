#include <stdlib.h>

void asegurar_conexion() {
    // Forzar la subida de la interfaz ethernet eth0
    system("su -c 'ifconfig eth0 up'");
    
    // Configurar IP estática para que el módem no te la cambie
    system("su -c 'ifconfig eth0 192.168.100.50 netmask 255.255.255.0'");
    
    // Añadir la puerta de enlace que mencionaste
    system("su -c 'route add default gw 192.168.100.1 eth0'");
}
