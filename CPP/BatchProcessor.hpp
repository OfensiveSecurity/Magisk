#include <iostream>
#include <filesystem>
#include <string>
#include <vector>

namespace fs = std::filesystem;

class BatchProcessor {
public:
    static void processDirectory(const std::string& rutaCarpeta, const std::string& clave, bool cifrar) {
        if (!fs::exists(rutaCarpeta) || !fs::is_directory(rutaCarpeta)) {
            std::cerr << "Error: La ruta no es una carpeta valida." << std::endl;
            return;
        }

        for (const auto& entrada : fs::directory_iterator(rutaCarpeta)) {
            if (fs::is_regular_file(entrada.path())) {
                std::string archivoOriginal = entrada.path().string();
                std::string archivoDestino;

                if (cifrar) {
                    archivoDestino = archivoOriginal + ".enc";
                } else {
                    // Si estamos descifrando, quitamos la extensión .enc
                    if (entrada.path().extension() == ".enc") {
                        archivoDestino = entrada.path().parent_path().string() + "/" + 
                                         entrada.path().stem().string();
                    } else {
                        continue; // Saltar archivos que no tengan extensión .enc
                    }
                }

                std::cout << "Procesando: " << entrada.path().filename() << "..." << std::endl;
                
                // Aquí llamamos a tu función principal del Kernel
                // (Suponiendo que procesarArchivoCompleto es accesible)
                procesarArchivoCompleto(archivoOriginal, archivoDestino, clave, cifrar);
            }
        }
    }
};
int main() {
    // ... (Código previo de clave segura) ...
    
    int modo;
    std::cout << "1. Procesar un archivo individual\n";
    std::cout << "2. Procesar una CARPETA completa\n";
    std::cout << "Seleccione: ";
    std::cin >> modo;

    if (modo == 2) {
        std::string ruta;
        std::cout << "Ingrese la ruta de la carpeta: ";
        std::cin >> ruta;
        
        std::string clave = leerClaveSegura("Clave para el lote: ");
        
        bool cifrar;
        std::cout << "¿(1) Cifrar o (2) Descifrar?: ";
        int op; std::cin >> op;
        cifrar = (op == 1);

        BatchProcessor::processDirectory(ruta, clave, cifrar);
        std::cout << "--- Proceso por lotes finalizado ---" << std::endl;
    }
    // ...
}
