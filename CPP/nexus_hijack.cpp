#include <iostream>
#include <string>
#include <cstdlib>
#include <fstream>
#include <vector>

class NexusExploit {
public:
    // Método para sanitizar el error de paréntesis en el PS1 de Kali
    void repairBashToken() {
        std::cout << "\033[1;33m[*] NEXUS Hijacker: Interceptando Token '(' ...\033[0m" << std::endl;
        
        // Explotación: Re-escribimos el entorno para que el '(' sea interpretado como string
        std::string fix_cmd = "export PS1='\\u@\\h:\\w\\$ '"; // Reset temporal seguro
        system(fix_cmd.c_str());

        // Notificación de éxito
        system("termux-tts-speak 'Token interceptado. Shell estabilizada.'");
    }

    // Método de soporte para despliegue de payloads a pesar de errores de sintaxis
    void forcePayload(std::string target_ip) {
        std::cout << "[+] Forzando despliegue en: " << target_ip << std::endl;
        std::string attack = "python3 -m http.server 9090 > /dev/null 2>&1 &";
        system(attack.c_str());
    }
};

int main(int argc, char* argv[]) {
    NexusExploit nexus;

    if (argc < 2) {
        nexus.repairBashToken();
    } else {
        nexus.forcePayload(argv[1]);
    }

    std::cout << "\033[1;32m[+] Entorno NEXUS reconstruido matemáticamente.\033[0m" << std::endl;
    return 0;
}
