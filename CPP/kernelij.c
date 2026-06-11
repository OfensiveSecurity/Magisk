#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

class ARC4 {
private:
    unsigned char S[256];
    int i, j;

public:
    // Constructor que inicializa los índices
    ARC4() : i(0), j(0) {}

    // 1. KSA: Key-Scheduling Algorithm
    // Prepara el estado interno basado en la clave proporcionada
    void setKey(const std::vector<unsigned char>& key) {
        for (int k = 0; k < 256; k++) {
            S[k] = k;
        }

        j = 0;
        for (i = 0; i < 256; i++) {
            j = (j + S[i] + key[i % key.size()]) % 256;
            std::swap(S[i], S[j]);
        }
        
        // Reiniciamos i y j para la generación de flujo
        i = j = 0;
    }

    // 2. PRGA: Pseudo-Random Generation Algorithm + XOR
    // Procesa los datos (cifra o descifra)
    void process(std::vector<unsigned char>& data) {
        for (size_t k = 0; k < data.size(); k++) {
            i = (i + 1) % 256;
            j = (j + S[i]) % 256;
            
            std::swap(S[i], S[j]);
            
            unsigned char K = S[(S[i] + S[j]) % 256];
            data[k] ^= K; // Operación XOR
        }
    }
};

int main() {
    // Ejemplo de uso:
    ARC4 cipher;
    
    // Nuestra "pieza de rompecabezas" requiere una clave y datos
    std::string keyStr = "ClaveSecreta";
    std::string message = "Hola, este es un mensaje seguro.";
    
    std::vector<unsigned char> key(keyStr.begin(), keyStr.end());
    std::vector<unsigned char> data(message.begin(), message.end());

    // --- CIFRADO ---
    cipher.setKey(key);
    cipher.process(data);
    
    std::cout << "Mensaje cifrado (hex): ";
    for(unsigned char b : data) printf("%02X ", b);
    std::cout << std::endl;

    // --- DESCIFRADO ---
    // Reiniciamos el kernel con la misma clave para volver al estado original
    cipher.setKey(key);
    cipher.process(data);
    
    std::string decrypted(data.begin(), data.end());
    std::cout << "Mensaje descifrado: " << decrypted << std::endl;

    return 0;
}
