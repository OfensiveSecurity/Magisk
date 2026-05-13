#include <iostream>
#include <cstdlib>

void show_menu() {
    std::system("clear");
    std::cout << "\033[1;34m=================================================\033[0m\n";
    std::cout << "\033[1;37m   NEXUS v6.0 - TACTICAL COMMAND CENTER         \033[0m\n";
    std::cout << "\033[1;34m=================================================\033[0m\n";
    std::cout << "1. [MODO MONITOR] - Activar wlan0 promiscuo\n";
    std::cout << "2. [AUTO-HUNTER]  - Escanear WPS y Handshakes\n";
    std::cout << "3. [DEAUTH STORM] - Forzar reconexión de clientes\n";
    std::cout << "4. [GEN WORDLIST] - Crear diccionario inteligente\n";
    std::cout << "5. [CLEANUP]      - Borrar huellas y logs\n";
    std::cout << "6. [EXIT]         - Salir al Shell\n";
    std::cout << "\033[1;34m-------------------------------------------------\033[0m\n";
    std::cout << "Seleccione una opción: ";
}

int main() {
    int opt;
    while (true) {
        show_menu();
        std::cin >> opt;

        switch(opt) {
            case 1: std::system("su -c nexus_monitor.sh"); break;
            case 2: std::system("su -c nexus_autopwn.sh"); break;
            case 3: std::system("su -c nexus_deauth.sh"); break;
            case 4: std::system("./nexus_gen"); break; // Tu generador C++
            case 5: std::system("su -c nexus_cleanup.sh"); break;
            case 6: return 0;
            default: std::cout << "Opción no válida.\n";
        }
        std::cout << "\nPresione Enter para continuar...";
        std::cin.ignore();
        std::cin.get();
    }
    return 0;
}
