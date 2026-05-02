#include <iostream>
#include <vector>
#include <fstream>

void generate_list() {
    // Palabras clave basadas en tu contexto y ubicación
    std::vector<std::string> keywords = {
        "Naucalpan", "Edomex", "Nexus", "MotoE13", "Satelite", 
        "Lambo", "Huracan", "CaneCorso", "2026", "Admin"
    };
    
    std::vector<std::string> suffixes = {"123", "!", "2026", "01", "*", "qwe"};
    
    std::ofstream file("nexus_wordlist.txt");
    
    for (const auto& word : keywords) {
        file << word << "\n"; // Palabra simple
        for (const auto& suff : suffixes) {
            file << word << suff << "\n";      // Palabra + Sufijo
            file << word << "_" << suff << "\n"; // Palabra + _ + Sufijo
        }
    }
    file.close();
}

int main() {
    std::cout << "[*] GENERANDO DICCIONARIO DE RECUPERACIÓN EN EL MOTO E13..." << std::endl;
    generate_list();
    std::cout << "[✓] 'nexus_wordlist.txt' creado con éxito." << std::endl;
    return 0;
}
