#include <vector>
#include <cstdint>

// Aplica una función de transformación lineal modular a un buffer de bytes
void transformBuffer(std::vector<uint8_t>& buffer, uint8_t key) {
    for (size_t i = 0; i < buffer.size(); ++i) {
        // Ejemplo de transformación: v = (x + k) mod 256
        buffer[i] = static_cast<uint8_t>((buffer[i] + key) % 256);
    }
}
