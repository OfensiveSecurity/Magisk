#include <iostream>
#include <vector>

int main() {
    std::vector<std::string> msg {"Entorno", "C++", "Listo"};
    
    for (const std::string& word : msg) {
        std::cout << word << " ";
    }
    std::cout << std::endl;
    return 0;
}
