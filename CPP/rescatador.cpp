#include <iostream>
#include <filesystem>
#include <unistd.h>

namespace fs = std::filesystem;

int main() {
    // Ruta al cargador real y al enlace roto
    const char* real_ld = "/usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2";
    const char* link_ld = "/lib64/ld-linux-x86-64.so.2";

    std::cout << "Iniciando bypass de librerias..." << std::endl;
    
    // Forzamos la creación del link usando llamadas al sistema
    unlink(link_ld); 
    if (symlink(real_ld, link_ld) == 0) {
        std::cout << "Link restaurado con exito." << std::endl;
    } else {
        perror("Error critico");
    }
    return 0;
}
