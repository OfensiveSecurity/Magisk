#include <iostream>
#include <filesystem>
#include <string>

namespace fs = std::filesystem;

int main() {
    // Definimos las rutas críticas que se rompieron
    std::string target = "/usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2";
    std::string link_path = "/lib64/ld-linux-x86-64.so.2";

    try {
        std::cout << "Iniciando reparación de enlaces de sistema..." << std::endl;

        // 1. Verificar si el directorio /lib64 existe
        if (!fs::exists("/lib64")) {
            fs::create_directory("/lib64");
            std::cout << "[+] Directorio /lib64 creado." << std::endl;
        }

        // 2. Eliminar el enlace roto si existe
        if (fs::exists(link_path) || fs::is_symlink(link_path)) {
            fs::remove(link_path);
            std::cout << "[!] Enlace antiguo removido." << std::endl;
        }

        // 3. Crear el nuevo enlace simbólico (El puente vital)
        fs::create_symlink(target, link_path);

        if (fs::is_symlink(link_path)) {
            std::cout << "------------------------------------------" << std::endl;
            std::cout << "[SUCCESS] Enlace restaurado correctamente." << std::endl;
            std::cout << "Ahora los binarios dinámicos deberían funcionar." << std::endl;
            std::cout << "------------------------------------------" << std::endl;
        }

    } catch (const fs::filesystem_error& e) {
        std::cerr << "ERROR DE SISTEMA: " << e.what() << std::endl;
        std::cerr << "Asegúrate de ejecutar esto con sudo o como root." << std::endl;
        return 1;
    }

    return 0;
}
