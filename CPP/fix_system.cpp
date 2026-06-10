#include <iostream>
#include <unistd.h>
#include <sys/stat.h>

int main() {
    // Definimos las rutas que suelen romperse en este conflicto
    const char* loader = "/usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2";
    const char* link_target = "/lib64/ld-linux-x86-64.so.2";

    std::cout << "[*] Intentando bypass de librerias dinamicas..." << std::endl;

    // 1. Asegurar que existe el directorio /lib64
    mkdir("/lib64", 0755);

    // 2. Forzar el enlace simbólico (usando syscalls de C)
    unlink(link_target); // Borrar si existe algo roto
    if (symlink(loader, link_target) == 0) {
        std::cout << "[OK] Sistema de enlaces restaurado." << std::endl;
        std::cout << "[!] Prueba ejecutar 'ls' o 'apt' ahora." << std::endl;
    } else {
        perror("[ERROR] No se pudo crear el enlace vital");
        return 1;
    }

    return 0;
}
