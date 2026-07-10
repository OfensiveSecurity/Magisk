#include <iostream>
#include <vector>
#include <string>

struct Machine {
    std::string name;
    std::string service;
    std::string vulnerability;
};

void start_challenge() {
    std::vector<Machine> labs = {
        {"NEXUS-01", "HTTP (Apache 2.4.41)", "Directory Traversal"},
        {"NEXUS-02", "SMB (Samba 3.0.20)", "Username map script (RCE)"},
        {"NEXUS-03", "SSH (OpenSSH 7.2p2)", "User Enumeration / Brute Force"}
    };

    int index = rand() % labs.size();
    std::cout << "\n[!] NUEVO OBJETIVO DETECTADO EN EL LABORATORIO:" << std::endl;
    std::cout << ">> Máquina: " << labs[index].name << std::endl;
    std::cout << ">> Servicio: " << labs[index].service << std::endl;
    std::cout << ">> Tu Misión: Explotar '" << labs[index].vulnerability << "' y obtener Root.\n" << std::endl;
}

int main() {
    srand(time(0));
    start_challenge();
    return 0;
}
