#include <iostream>
#include <fstream>
#include <unistd.h>

void vibrate(int duration_ms) {
    std::ofstream v_file("/sys/class/timed_output/vibrator/enable");
    if (v_file.is_open()) {
        v_file << duration_ms;
        v_file.close();
        usleep(duration_ms * 1000 + 100000); // Esperar a que termine + pequeño delay
    }
}

int main() {
    std::cout << "[*] SUBIDA A GITHUB FINALIZADA: akdmjeau-eng/Magisk" << std::endl;
    
    // Secuencia de éxito: 1 larga, 3 cortas
    vibrate(800);  // Larga
    usleep(200000);
    vibrate(200);  // Corta
    vibrate(200);  // Corta
    vibrate(200);  // Corta
    
    std::cout << "[✓] Alerta háptica enviada. Nexus Core a salvo." << std::endl;
    return 0;
}
