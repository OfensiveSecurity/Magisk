#include <iostream>
#include <string>
#include <unistd.h>

// Filtro específico para tus equipos (MAC de Laptop/Antena)
const std::string TARGET_MAC = "XX:XX:XX:XX:XX:XX"; 

void startSniffing() {
    std::cout << "[📡] INICIANDO CAPTURA DE PAQUETES EN MODO MONITOR..." << std::endl;
    
    // Comando para capturar handshakes y guardarlos en un archivo .pcap
    // Filtramos por la MAC de tu hardware sustraído
    std::string cmd = "tsu -c 'tcpdump -i wlan0 -vv -e ether host " + TARGET_MAC + " -w ~/nexus/evidence/capture.pcap &'";
    
    if (system(cmd.c_str()) == 0) {
        std::cout << "[✓] Sniffer activo. Guardando evidencia en /evidence/capture.pcap" << std::endl;
    } else {
        std::cerr << "[!] Error: Asegúrate de tener el Modo Monitor activo en el E13." << std::endl;
    }
}

int main() {
    startSniffing();
    return 0;
}
