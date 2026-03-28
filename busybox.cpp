#include <iostream>
#include <sys/stat.h>
#include <string>

class NexusEnvironment {
public:
    // Verifica si busybox está en el PATH o en rutas comunes de NetHunter
    bool checkBusyBox() {
        std::string paths[] = {"/system/xbin/busybox", "/system/bin/busybox", "/data/adb/magisk/busybox", "/data/data/com.termux/files/usr/bin/busybox"};
        
        for (const auto& path : paths) {
            struct stat buffer;
            if (stat(path.c_str(), &buffer) == 0) {
                std::cout << "\033[1;32m[+] BusyBox detectado en: " << path << "\033[0m\n";
                return true;
            }
        }
        return false;
    }

    void fixBusyBoxSupport() {
        if (!checkBusyBox()) {
            std::cout << "\033[1;31m[!] ALERTA: NetHunter fallará. BusyBox no detectado.\033[0m\n";
            std::cout << "[*] Sugerencia: Instala el módulo BusyBox desde Magisk o usa 'pkg install busybox' en Termux.\n";
        } else {
            std::cout << "[+] Soporte de comandos del sistema: OK\n";
        }
    }
};
