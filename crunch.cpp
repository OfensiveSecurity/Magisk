#include <iostream>
#include <fstream>
#include <vector>
#include <string>

int main() {
    std::cout << "[*] NEXUS: Generando Diccionario Inteligente (Wordlist)...\n";

    std::vector<std::string> base = {"Admin", "Izzi", "Infinitum", "Totalplay", "Red"};
    std::vector<std::string> years = {"2024", "2025", "2026", "2023"};
    std::vector<std::string> chars = {"*", "!", "@", "2026"};

    std::ofstream wordlist("nexus_wordlist.txt");

    for (const auto& b : base) {
        for (const auto& y : years) {
            wordlist << b << y << "\n";          // Ejemplo: Izzi2026
            wordlist << b << "_" << y << "\n";    // Ejemplo: Izzi_2026
            for (const auto& c : chars) {
                wordlist << b << y << c << "\n"; // Ejemplo: Izzi2026!
            }
        }
    }

    wordlist.close();
    std::cout << "\033[1;32m[+] Diccionario de Élite generado: nexus_wordlist.txt\033[0m\n";
    return 0;
}
