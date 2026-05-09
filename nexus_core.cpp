#include <iostream>
#include <cstdlib>

void nexus_fix_nethunter() {
    std::cout << "\033[1;33m[*] Iniciando Protocolo de Reparación NetHunter...\033[0m\n";
    
    // 1. Localizar BusyBox en Termux
    const char* find_bb = "which busybox > /dev/null 2>&1";
    if (system(find_bb) != 0) {
        std::cout << "[!] BusyBox no instalado en Termux. Instalando...\n";
        system("pkg install busybox -y");
    }

    // 2. Inyectar en la ruta de sistema (Requiere Root de Magisk)
    // NetHunter busca en /system/xbin o /system/bin
    std::cout << "[*] Elevando privilegios para vinculación de binarios...\n";
    
    const char* inject_cmd = "su -c 'mount -o remount,rw / && "
                             "ln -sf $(which busybox) /system/xbin/busybox && "
                             "ln -sf $(which busybox) /system/bin/busybox && "
                             "busybox --install -s /system/xbin'";

    int result = system(inject_cmd);

    if (result == 0) {
        std::cout << "\033[1;32m[+] ÉXITO: BusyBox vinculado. Reinicia la App de NetHunter.\033[0m\n";
    } else {
        std::cout << "\033[1;31m[!] ERROR: No se pudo escribir en /system. Verifica Magisk.\033[0m\n";
    }
}
