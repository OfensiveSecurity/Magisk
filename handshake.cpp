#include <iostream>
#include <cstdlib>

void analyze_captured_loot() {
    std::cout << "[*] NEXUS: Analizando capturas para el reporte OSCP...\n";
    
    // Verificamos si el archivo de captura existe y tiene datos
    const char* check_cmd = "su -c 'hcxpcaptool -z /sdcard/nexus_loot/hash_ready.txt /sdcard/nexus_loot/handshakes-01.cap'";
    
    if (system(check_cmd) == 0) {
        std::cout << "\033[1;32m[+] ÉXITO: Handshake convertido y listo para crackear.\033[0m\n";
    } else {
        std::cout << "\033[1;31m[!] FALLO: No se capturó un Handshake completo aún.\033[0m\n";
    }
}
