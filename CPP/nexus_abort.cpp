#include <iostream>
#include <unistd.h>

void emergency_abort() {
    std::cout << "[🚨] ABORTANDO MODO ENFOQUE... ¡PRIORIDAD AL RADAR!" << std::endl;

    // 1. Reactivar todas las notificaciones
    system("settings put global zen_mode 0");

    // 2. Detener simuladores y laboratorios OSCP
    system("pkill -f nexus_oscp_trainer");
    system("pkill -f msfconsole");

    // 3. Lanzar el rastreador acústico y visual al máximo
    system("~/nexus/bin/nexus_beep --max &");
    system("python3 ~/nexus/bin/nexus_heatmap.py");
    system("python3 -m http.server 8080 &");

    std::cout << "[✓] SISTEMA EN MODO CAZA TOTAL. REVISA EL DASHBOARD." << std::endl;
}

int main() {
    emergency_abort();
    return 0;
}
