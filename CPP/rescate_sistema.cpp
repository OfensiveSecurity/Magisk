#include <iostream>
#include <filesystem> // Requiere C++17
#include <system_error>

namespace fs = std::filesystem;

int main() {
    // Rutas críticas para sistemas de 64 bits (x86_64)
    const std::string origen_loader = "/usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2";
    const std::string destino_link  = "/lib64/ld-linux-x86-64.so.2";
    const std::string carpeta_lib64 = "/lib64";

    std::cout << "--- Herramienta de Soporte de Emergencia C++ ---" << std::endl;

    try {
        // 1. Crear el directorio /lib64 si fue borrado
        if (!fs::exists(carpeta_lib64)) {
            std::cout << "[*] Creando directorio " << carpeta_lib64 << "..." << std::endl;
            fs::create_directory(carpeta_lib64);
        }

        // 2. Eliminar cualquier enlace roto previo para evitar colisiones
        if (fs::exists(destino_link) || fs::is_symlink(destino_link)) {
            std::cout << "[!] Limpiando enlace antiguo/roto..." << std::endl;
            fs::remove(destino_link);
        }

        // 3. Crear el enlace simbólico vital (El "Puente")
        std::cout << "[*] Restaurando enlace: " << destino_link << " -> " << origen_loader << std::endl;
        fs::create_symlink(origen_loader, destino_link);

        if (fs::is_symlink(destino_link)) {
            std::cout << "\n[EXITO] Sistema recuperado. Intenta ejecutar 'ls' ahora." << std::endl;
        }

    } catch (const fs::filesystem_error& e) {
        std::cerr << "\n[ERROR] No se pudo reparar: " << e.what() << std::endl;
        std::cerr << "TIP: Asegurate de ejecutar como ROOT (sudo)." << std::endl;
        return 1;
    }

    return 0;
}
