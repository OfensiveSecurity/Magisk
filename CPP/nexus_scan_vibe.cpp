#include <iostream>
#include <cstdlib>
#include <string>

int main() {
    std::string target = "192.168.1.11";
    std::cout << "\033[1;34m[*] NEXUS: Verificando supervivencia de " << target << "...\033[0m" << std::endl;

    // 1. Escaneo rápido (Ping de 1 paquete, espera 1 segundo)
    std::string ping_cmd = "ping -c 1 -W 1 " + target + " > /dev/null 2>&1";
    int result = system(ping_cmd.c_str());

    if (result == 0) {
        std::cout << "\033[1;32m[+] OBJETIVO ACTIVO. Activando respuesta háptica...\033[0m" << std::endl;
        
        // 2. Prueba de Vibración (Confirmación de hardware)
        system("termux-vibrate -d 500"); 
        
        // 3. Confirmación Vocal
        system("termux-tts-speak 'Objetivo alcanzable. Sistema listo para explotación.'");
    } else {
        std::cout << "\033[1;31m[!] OBJETIVO CAÍDO o FILTRADO (Timeout).\033[0m" << std::endl;
        system("termux-tts-speak 'Alerta. El objetivo no responde.'");
    }

    return 0;
}
