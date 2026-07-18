#include <iostream>
#include <unistd.h>

int main() {
    if (getuid() == 0) {
        std::cout << "\033[1;32m[+] NEXUS: Root verificado. Procediendo...\033[0m\n";
    } else {
        std::cout << "\033[1;31m[!] ALERTA: Magisk NO está activo.\033[0m\n";
        std::cout << "[*] Sin Root, NetHunter es solo una interfaz vacía.\n";
    }
    return 0;
}
