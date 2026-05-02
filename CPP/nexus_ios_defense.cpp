#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <filesystem>

namespace fs = std::filesystem;

// Simulación de una llave maestra derivada de tu hardware Moto E13
const std::string MASTER_KEY = "NEXUS_E13_UNISOC_2026_SECURE";

void encryptFile(const std::string& filePath) {
    std::ifstream inFile(filePath, std::ios::binary);
    std::string content((std::istreambuf_iterator<char>(inFile)), std::istreambuf_iterator<char>());
    inFile.close();

    // XOR Simple para demostración (En producción usar AES-256)
    for (size_t i = 0; i < content.size(); ++i) {
        content[i] ^= MASTER_KEY[i % MASTER_KEY.length()];
    }

    std::ofstream outFile(filePath + ".nexus_locked", std::ios::binary);
    outFile << content;
    outFile.close();
    
    fs::remove(filePath); // Eliminar el original
}

void deployDefense(const std::string& targetDir) {
    std::cout << "[⚠️] INICIANDO CIFRADO DE DEFENSA EN: " << targetDir << std::endl;
    for (const auto& entry : fs::recursive_directory_iterator(targetDir)) {
        if (entry.is_regular_file()) {
            encryptFile(entry.path().string());
            std::cout << "[+] Bloqueado: " << entry.path().filename() << std::endl;
        }
    }
}

int main() {
    // Si el radar detecta que el iPhone se aleja o hay intrusión:
    deployDefense("/sdcard/NEXUS_PEN200_LABS"); 
    std::cout << "[🏁] DEFENSA COMPLETADA. DATOS INACCESIBLES SIN LLAVE." << std::endl;
    return 0;
}
