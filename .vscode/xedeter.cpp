#include <iostream>
#include <vector>
#include <cmath>
#include <cstdint>

// Estructura para representar un color RGB de 24 bits
struct Color {
    uint8_t r, g, b;
};

// Estructura para representar una partícula física
struct Particle {
    float x, y;
    float vx, vy;
    
    // Obtiene la velocidad escalar (magnitud)
    float getSpeed() const {
        return std::sqrt(vx * vx + vy * vy);
    }
};

// Genera una paleta de colores de 256 posiciones (Azul = Lento, Rojo = Rápido)
std::vector<Color> generateSpeedPalette() {
    std::vector<Color> palette(256);
    for (int i = 0; i < 256; ++i) {
        palette[i].r = static_cast<uint8_t>(i);          // Aumenta el rojo con la velocidad
        palette[i].g = 0;
        palette[i].b = static_cast<uint8_t>(255 - i);    // Disminuye el azul con la velocidad
    }
    return palette;
}

int main() {
    const float MAX_SPEED = 50.0f; // Velocidad máxima esperada para normalizar
    auto palette = generateSpeedPalette();

    // Ejemplo de partículas con distintas velocidades
    std::vector<Particle> particles = {
        {0.0f, 0.0f, 5.0f, 5.0f},   // Lenta
        {0.0f, 0.0f, 20.0f, 25.0f}, // Media
        {0.0f, 0.0f, 35.0f, 40.0f}  // Rápida
    };

    // Actualización y mapeo de color
    for (size_t i = 0; i < particles.size(); ++i) {
        float speed = particles[i].getSpeed();
        
        // Mapeo normalizado de la velocidad a un índice [0, 255]
        int colorIndex = static_cast<int>((speed / MAX_SPEED) * 255.0f);
        
        // Clamping para evitar desbordamiento del índice
        if (colorIndex > 255) colorIndex = 255;
        if (colorIndex < 0) colorIndex = 0;

        Color particleColor = palette[colorIndex];

        std::cout << "Partícula " << i 
                  << " | Velocidad: " << speed 
                  << " | Color RGB: (" 
                  << (int)particleColor.r << ", " 
                  << (int)particleColor.g << ", " 
                  << (int)particleColor.b << ")\n";
    }

    return 0;
}
