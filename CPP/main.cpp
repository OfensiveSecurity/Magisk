#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cstdint>
#include "ARC4.hpp"

// Función para generar un verificador simple de la clave
uint32_t calcularCheck(const std::string& clave) {
    uint32_t check = 0xABCDEFFF;
    for (char c : clave) {
        check = ((check << 5) + check) + c;
    }
    return check;
}

void procesarArchivoCompleto(const std::string& entrada, const std::string& salida, const std::string& clave, bool cifrar) {
    std::ifstream fIn(entrada, std::ios::binary);
    if (!fIn) { std::cerr << "Error al abrir entrada.\n"; return; }

    ARC4 kernel;
    kernel.setKey(clave);
    uint32_t checkClave = calcularCheck(clave);

    if (cifrar) {
        // --- MODO CIFRADO ---
        std::ofstream fOut(salida, std::ios::binary);
        // Escribimos la cabecera: Sello + Checksum
        uint32_t sello = 0x52433441; // "ARC4" en hex
        fOut.write(reinterpret_cast<char*>(&sello), 4);
        fOut.write(reinterpret_cast<char*>(&checkClave), 4);

        // Leemos y ciframos el resto
        std::vector<uint8_t> buffer((std::istreambuf_iterator<char>(fIn)), std::istreambuf_iterator<char>());
        kernel.process(buffer);
        fOut.write(reinterpret_cast<char*>(buffer.data()), buffer.size());
        std::cout << "Archivo cifrado con exito.\n";
    } 
    else {
        // --- MODO DESCIFRADO ---
        uint32_t selloLeido, checkLeido;
        fIn.read(reinterpret_cast<char*>(&selloLeido), 4);
        fIn.read(reinterpret_cast<char*>(&checkLeido), 4);

        if (selloLeido != 0x52433441) {
            std::cerr << "Error: El archivo no parece estar cifrado por este sistema.\n";
            return;
        }
        if (checkLeido != checkClave) {
            std::cerr << "Error: ¡CLAVE INCORRECTA! El archivo no se puede descifrar.\n";
            return;
        }

        std::vector<uint8_t> buffer((std::istreambuf_iterator<char>(fIn)), std::istreambuf_iterator<char>());
        kernel.process(buffer);
        
        std::ofstream fOut(salida, std::ios::binary);
        fOut.write(reinterpret_cast<char*>(buffer.data()), buffer.size());
        std::cout << "Archivo descifrado con exito.\n";
    }
}
