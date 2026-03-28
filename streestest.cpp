#include <iostream>
#include <cstdlib>

int main() {
    std::cout << "\033[1;33m[*] NEXUS: Iniciando Simulación de Combate...\033[0m\n";

    // 1. Test de Elevación (Root)
    std::cout << "[1/4] Verificando Magisk SU... ";
    if (system("su -c 'id' > /dev/null") == 0) {
        std::cout << "\033[1;32mOK\033[0m\n";
    } else {
        std::cout << "\033[1;31mFALLO (Revisa Magisk)\033[0m\n";
    }

    // 2. Test de Interfaz (WLAN0)
    std::cout << "[2/4] Verificando Hardware de Red... ";
    if (system("iw dev wlan0 info > /dev/null") == 0) {
        std::cout << "\033[1;32mOK\033[0m\n";
    } else {
        std::cout << "\033[1;31mFALLO (¿Chip compatible?)\033[0m\n";
    }

    // 3. Test de Inyección (Packet Injection)
    std::cout << "[3/4] Probando Inyección de Paquetes... \n";
    system("su -c 'aireplay-ng --test wlan0'");

    // 4. Test de Almacenamiento (Loot)
    std::cout << "[4/4] Verificando Directorio de Capturas... ";
    if (system("mkdir -p /sdcard/nexus_loot") == 0) {
        std::cout << "\033[1;32mOK\033[0m\n";
    }

    std::cout << "\n\033[1;32m[!] SIMULACIÓN COMPLETADA. SISTEMA LISTO PARA OSCP.\033[0m\n";
    return 0;
}
