#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <cstdlib>

void bloquear_numero(std::string numero) {
    // Usamos el comando de sistema para bloquear el tráfico de red de ese origen
    std::string comando = "su -c 'iptables -A INPUT -s " + numero + " -j DROP'";
    system(comando.c_str());
    std::cout << "[BLOCK] Número " << numero << " enviado al vacío." << std::endl;
}

int main() {
    std::cout << "🛡️ Iniciando Escudo Anti-Spam Magisk..." << std::endl;
    
    // Lista de prefijos comunes de spam (ejemplo)
    std::vector<std::string> lista_negra = {"800", "900", "444"};

    for(const auto& prefijo : lista_negra) {
        bloquear_numero(prefijo);
    }

    return 0;
}
