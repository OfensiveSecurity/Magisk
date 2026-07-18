#include <iostream>
#include <vector>
#include <string>

void scan_port(std::string ip, int port) {
    // Usamos nc (netcat) con un timeout de 1 segundo para rapidez matemática
    std::string cmd = "nc -zv -w 1 " + ip + " " + std::to_string(port) + " > /dev/null 2>&1";
    if (system(cmd.c_str()) == 0) {
        std::cout << "\033[1;32m[+] Puerto " << port << " ABIERTO\033[0m" << std::endl;
        system("termux-vibrate -d 100"); // Vibración corta por cada puerto hallado
    }
}

int main() {
    std::string target = "192.168.1.11";
    std::vector<int> critical_ports = {80, 445, 3389}; // HTTP, SMB, RDP

    std::cout << "\033[1;36m[*] NEXUS SCANNER: Analizando " << target << "...\033[0m" << std::endl;

    for (int port : critical_ports) {
        scan_port(target, port);
    }

    system("termux-tts-speak 'Escaneo de puertos completado.'");
    return 0;
}
