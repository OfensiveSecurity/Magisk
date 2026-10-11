#include <iostream>
#include <string>
#include <cmath>
#include <cctype>

class PasswordEvaluator {
public:
    static double calculateEntropy(std::string_view password) {
        bool hasLower = false, hasUpper = false, hasDigit = false;
        
        for (char ch : password) {
            if (std::islower(ch)) hasLower = true;
            else if (std::isupper(ch)) hasUpper = true;
            else if (std::isdigit(ch)) hasDigit = true;
        }

        // Determinar el tamaño del alfabeto base según los tipos detectados
        int poolSize = 0;
        if (hasLower) poolSize += 26;
        if (hasUpper) poolSize += 26;
        if (hasDigit) poolSize += 10;

        if (poolSize == 0 || password.empty()) return 0.0;

        // Fórmula de entropía: L * log2(R)
        return password.length() * std::log2(poolSize);
    }
};

int main() {
    // Ejemplo con una clave típica de módem de 8 caracteres alfanuméricos
    std::string mockModemKey = "aB7kX9pW"; 
    
    double bits = PasswordEvaluator::calculateEntropy(mockModemKey);
    
    std::cout << "Analisis de robustez para la clave: " << mockModemKey << std::endl;
    std::cout << "Entropia calculada: " << bits << " bits." << std::endl;
    
    if (bits < 60.0) {
        std::cout << "Alerta: La longitud de 8 caracteres limita la seguridad estructural a largo plazo." << std::endl;
    } else {
        std::cout << "Estructura aceptable para uso residencial basico." << std::endl;
    }

    return 0;
}
