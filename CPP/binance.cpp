#include <sys/stat.h>
#include <stdio.h>

void check_critical_infrastructure() {
    struct stat st = {0};
    if (stat("/home/nexus/core/drivers", &st) == -1) {
        printf("[🚨] ERROR CRÍTICO: 'drivers/' NO ENCONTRADO. EJECUTANDO AUTO-REPARACIÓN...\n");
        system("bash ~/nexus/scripts/repair_drivers.sh");
    } else {
        printf("[🛡️] INFRAESTRUCTURA DE DRIVERS: OK\n");
    }
}
