#include <iostream>
#include <unistd.h>
#include <sys/stat.h>

int main() {
    // Intentamos restaurar el cargador de 64 bits que rompió Parrot/Kali
    const char* loader_path = "/usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2";
    const char* link_path = "/lib64/ld-linux-x86-64.so.2";

    std::cout << "[*] Iniciando rescate de sistema..." << std::endl;

    // 1. Crear directorio base
    mkdir("/lib64", 0755);

    // 2. Eliminar link roto y crear el nuevo (Syscall directa)
    unlink(link_path);
    if (symlink(loader_path, link_path) == 0) {
        std::cout << "[OK] Enlace restaurado. El sistema deberia volver a la vida." << std::endl;
    } else {
        perror("[ERROR] No se pudo crear el enlace");
        return 1;
    }
    return 0;
}
