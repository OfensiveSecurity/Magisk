#ifndef ARC4_HPP
#define ARC4_HPP

#include <vector>
#include <cstdint>

class ARC4 {
public:
    ARC4();
    // Prepara el kernel con una clave específica
    void setKey(const std::vector<uint8_t>& key);
    // Cifra o descifra los datos (operación in-place)
    void process(std::vector<uint8_t>& data);

private:
    uint8_t S[256];
    uint8_t i, j; // Usamos uint8_t para que el desbordamiento a 256 sea automático
    void ksa(const std::vector<uint8_t>& key);
};

#endif
