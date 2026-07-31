#include <iostream>
#include <string>

void start_nexus_sniffing(std::string target_bssid, int channel) {
    std::cout << "[*] NEXUS: Iniciando captura en el canal " << channel << "...\n";
    
    // Construimos el comando de airodump-ng
    std::string cmd = "su -c 'airodump-ng --bssid " + target_bssid + 
                      " --channel " + std::to_string(channel) + 
                      " -w /sdcard/nexus_loot/capture wlan0'";
    
    std::cout << "[>] Ejecutando: " << cmd << "\n";
    system(cmd.c_str());
}
