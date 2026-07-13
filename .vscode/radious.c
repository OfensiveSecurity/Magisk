#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void check_radius_status() {
    // Comando para buscar errores de BlastRADIUS en el log
    int status = system("grep -q 'BlastRADIUS' /var/log/freeradius/radius.log");

    if (status == 0) {
        printf("[ALERTA NEXUS] Intento de BlastRADIUS detectado en la red.\n");
        printf("[ACCION] Reforzando seguridad en el soporte de 7V...\n");
        // Aquí podrías ejecutar un script de bloqueo
    } else {
        printf("[SISTEMA] RADIUS operando normalmente sobre Fibra -6dB.\n");
    }
}

int main() {
    printf("--- Iniciando Monitor de Autenticación Nexus ---\n");
    while(1) {
        check_radius_status();
        system("sleep 30");
    }
    return 0;
}