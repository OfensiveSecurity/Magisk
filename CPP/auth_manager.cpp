#include <iostream>
#include <fstream>
#include <string>
#include <unistd.h>

void write_log(std::string message, std::string log_path) {
    // VULNERABILIDAD: No se sanitiza 'log_path'. 
    // Permite "Path Traversal" o inyección de archivos.
    std::string command = "echo '" + message + "' >> " + log_path;
    system(command.c_str()); 
}

int main(int argc, char* argv[]) {
    if (argc < 3) {
        std::cout << "Uso: ./auth_manager <mensaje> <ruta_log>" << std::endl;
        return 1;
    }

    // Simulamos que este proceso corre con privilegios elevados
    std::cout << "[*] Procesando log de auditoría..." << std::endl;
    write_log(argv[1], argv[2]);
    
    return 0;
}
