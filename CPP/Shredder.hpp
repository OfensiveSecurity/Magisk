#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cstdio> // Para remove()

class Shredder {
public:
    static bool shred(const std::string& ruta) {
        std::fstream archivo(ruta, std::ios::binary | std::ios::in | std::ios::out);
        if (!archivo.is_open()) return false;

        // 1. Obtener el tamaño del archivo
        archivo.seekg(0, std::ios::end);
        std::streamsize tamano = archivo.tellg();
        
        // 2. Sobrescribir con ceros (Paso 1 de seguridad)
        archivo.seekg(0, std::ios::beg);
        std::vector<char> ceros(tamano, 0);
        archivo.write(ceros.data(), tamano);
        archivo.flush();

        // 3. Sobrescribir con patrones aleatorios (Paso 2 de seguridad)
        archivo.seekg(0, std::ios::beg);
        for (std::streamsize i = 0; i < tamano; ++i) {
            char r = static_cast<char>(rand() % 256);
            archivo.put(r);
        }
        archivo.close();

        // 4. Eliminar el archivo del sistema de archivos
        if (std::remove(ruta.c_str()) == 0) {
            return true;
        }
        return false;
    }
};
// ... después de guardar el archivo cifrado con éxito ...

char respuesta;
std::cout << "¿Desea borrar de forma SEGURA el archivo original? (s/n): ";
std::cin >> respuesta;

if (respuesta == 's' || respuesta == 'S') {
    std::cout << "Triturando archivo original..." << std::endl;
    if (Shredder::shred(nombreEntrada)) {
        std::cout << "[OK] El archivo original ha sido destruido permanentemente." << std::endl;
    } else {
        std::cout << "[ERROR] No se pudo triturar el archivo." << std::endl;
    }
}
