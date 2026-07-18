// bug_hunter_bridge.c
#include <stdio.h>
#include <stdlib.h>

void trigger_bughunter_broadcast() {
    printf("[🛡️] KALI BUGHUNTER: Elevando prioridad de transmisión...\n");
    
    // Comando para inyectar paquetes de alerta en el aire (Layer 2)
    // Esto hace que la alerta sea "vociferada" por Wi-Fi sin necesidad de estar conectado
    system("aireplay-ng --deauth 5 -a FF:FF:FF:FF:FF:FF wlan0mon");
    
    printf("[✅] VOCIFERACIÓN MASIVA COMPLETADA.\n");
}
