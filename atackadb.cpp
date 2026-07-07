#include <iostream>
#include <sys/stat.h>

void verify_boot_image() {
    const char* boot_path = "/sdcard/boot.img";
    struct stat buffer;
    
    std::cout << "[*] NEXUS: Verificando integridad del volcado...\n";
    
    if (stat(boot_path, &buffer) == 0) {
        float size_mb = buffer.st_size / (1024.0 * 1024.0);
        std::cout << "\033[1;32m[+] Archivo encontrado: " << size_mb << " MB\033[0m\n";
        std::cout << "[>] Ahora abre la App de Magisk y selecciona este archivo.\n";
    } else {
        std::cout << "\033[1;31m[!] ERROR: No se encontró el boot.img en la SD.\033[0m\n";
        std::cout << "[?] ¿Ejecutaste el comando 'dd' en ADB?\n";
    }
}
