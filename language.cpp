#include <iostream>
#include <fstream>

void check_magisk_status() {
    // Intentamos leer un directorio que solo existe con Root real
    std::ifstream root_check("/data/adb/magisk");
    
    if (root_check.good()) {
        std::cout << "\033[1;32m[+] NEXUS: Magisk Binario Detectado. Sistema Operativo.\033[0m\n";
    } else {
        std::cout << "\033[1;31m[!] CRÍTICO: Magisk App presente pero BINARIO AUSENTE.\033[0m\n";
        std::cout << "[*] Estado: Solo lectura. Los módulos de NetHunter no cargarán.\n";
    }
}
