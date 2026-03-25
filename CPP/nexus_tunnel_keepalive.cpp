#include <iostream>
#include <unistd.h>

int main() {
    std::cout << "[🌐] INICIANDO PUENTE REMOTO NEXUS..." << std::endl;

    while(true) {
        // Intentar abrir el túnel hacia tu servidor de respaldo o PC nueva
        // -R 8080:localhost:22 mapea el SSH de tu E13 al puerto 8080 remoto
        std::string ssh_cmd = "ssh -N -R 8080:localhost:2222 user@tu-servidor-remoto.com";
        
        std::cout << "[*] Intentando conexión..." << std::endl;
        int status = system(ssh_cmd.c_str());

        if (status != 0) {
            std::cout << "[!] Conexión perdida. Reintentando en 30 segundos..." << std::endl;
            sleep(30);
        }
    }
    return 0;
}
