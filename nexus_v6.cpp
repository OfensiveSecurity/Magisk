#include <iostream>
#include <fstream>

void generate_tactical_cheat_sheet() {
    std::cout << "[*] NEXUS: Generando Diccionario de Comandos para Bugjaeger...\n";

    std::ofstream file("nexus_commands.txt");
    file << "=== NEXUS TACTICAL COMMANDS ===\n";
    file << "[ROOT] su -c 'setenforce 0' (Permisivo para NetHunter)\n";
    file << "[NET] ip addr show wlan0 (Ver IP para Wireless Debug)\n";
    file << "[BOOT] reboot bootloader (Entrar a modo Flash)\n";
    file << "[FIX] su -c 'mount -o remount,rw /system' (Habilitar escritura)\n";
    file.close();

    std::cout << "\033[1;32m[+] Diccionario generado en /sdcard/nexus_commands.txt\033[0m\n";
}
