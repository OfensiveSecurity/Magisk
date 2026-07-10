#include <stdio.h>
#include <stdlib.h>

void escanear_red() {
    printf("--- Buscando dispositivos en la red del módem ---\n");
    
    // Usamos arp-scan para obtener IPs y MACs rápidamente
    // Si no lo tienes en Termux: pkg install arp-scan
    system("su -c 'arp-scan --interface=eth0 192.168.100.0/24'");
}

int main() {
    escanear_red();
    return 0;
}
