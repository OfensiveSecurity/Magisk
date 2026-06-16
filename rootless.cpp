#include <iostream>
#include <string>

void launch_nexus_rootless(std::string module_name) {
    std::cout << "[*] Lanzando modulo " << module_name << " en modo Rootless...\n";
    
    // Usamos proot-distro para simular el entorno de Kali sin root real
    std::string command = "proot-distro login kali-nethunter --user nexus -- shared-tmp " + module_name;
    
    if (system(command.c_str()) == 0) {
        std::cout << "[+] Ejecucion completada en entorno aislado.\n";
    } else {
        std::cout << "[!] Error: El entorno Rootless no esta configurado.\n";
    }
}
