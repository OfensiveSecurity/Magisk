#include <iostream>
#include <unistd.h>
#include <sys/stat.h>

int main() {
    // Rutas para arquitectura x86_64 (común en emuladores/servidores)
    const char* real_ld = "/usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2";
    const char* link_ld = "/lib64/ld-linux-x86-64.so.2";

    std::cout << "[*] Restaurando el cargador de librerias de C++..." << std::endl;

    // Intentamos crear el link vital
    unlink(link_ld);
    if (symlink(real_ld, link_ld) == 0) {
        std::cout << "[OK] Enlace recreado exitosamente." << std::endl;
    } else {
        perror("[ERROR] No se pudo restaurar el sistema");
        return 1;
    }
    return 0;
}
