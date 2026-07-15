#include <cstdlib>
#include <iostream>

int main() {
    std::cout << "Ejecutando ss...\n";
    system("ss -tulpn");

    std::cout << "\nEjecutando Binwalk sobre ejemplo.bin...\n";
    system("binwalk ejemplo.bin");

    std::cout << "\nEscaneo Nmap de tu propia máquina...\n";
    system("nmap 127.0.0.1");

    return 0;
}