#include <iostream>
#include <vector>
#include <cassert>
#include "ARC4.hpp"
#include "Compressor.hpp"

void test_ciclo_completo() {
    std::cout << "[TEST] Iniciando prueba de ciclo completo (Cifrado + Compresion)..." << std::endl;

    // 1. Preparar datos de prueba
    std::string textoOriginal = "Datos de prueba repetitivos: AAAAAABBBBBB12345";
    std::vector<uint8_t> datos(textoOriginal.begin(), textoOriginal.end());
    std::string clave = "PasswordTest123";

    // 2. Proceso de Ida (Comprimir -> Cifrar)
    std::vector<uint8_t> procesado = Compressor::compress(datos);
    ARC4 cipher;
    cipher.setKey(clave);
    cipher.process(procesado);

    // 3. Proceso de Vuelta (Descifrar -> Descomprimir)
    cipher.setKey(clave); // Reiniciar kernel con misma clave
    cipher.process(procesado);
    std::vector<uint8_t> recuperado = Compressor::decompress(procesado);

    // 4. Verificación (Aserción)
    std::string textoFinal(recuperado.begin(), recuperado.end());
    
    if (textoOriginal == textoFinal) {
        std::cout << "✅ PRUEBA SUPERADA: El mensaje recuperado es identico." << std::endl;
    } else {
        std::cerr << "❌ ERROR: El mensaje recuperado NO coincide." << std::endl;
        exit(1);
    }
}

int main() {
    try {
        test_ciclo_completo();
        std::cout << "\n[EXITO] Todas las piezas del rompecabezas encajan perfectamente." << std::endl;
    } catch (const std::exception& e) {
        std::cerr << "Fallo critico en los tests: " << e.what() << std::endl;
        return 1;
    }
    return 0;
}
