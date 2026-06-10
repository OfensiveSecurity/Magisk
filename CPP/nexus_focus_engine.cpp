#include <iostream>
#include <unistd.h>

void start_focus_mode(int minutes) {
    std::cout << "[🔒] ENTRANDO EN MODO ENFOQUE (50 MINUTOS)..." << std::endl;
    
    // 1. Bloquear notificaciones (Vía comandos de sistema Android/Magisk)
    system("settings put global zen_mode 1"); 
    
    // 2. Mantener solo el Radar en alta prioridad
    system("renice -n -20 -p $(pgrep nexus_beep)");

    // 3. Temporizador
    sleep(minutes * 60);

    // 4. Salir de modo enfoque
    system("settings put global zen_mode 0");
    std::cout << "[🔓] CICLO COMPLETADO. DESCANSO DE 10 MINUTOS." << std::endl;
}

int main() {
    start_focus_mode(50);
    return 0;
}
