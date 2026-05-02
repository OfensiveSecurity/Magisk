#include <iostream>
#include <pcap.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>

void packet_handler(u_char *args, const struct pcap_pkthdr *header, const u_char *packet) {
    struct ip *ip_header = (struct ip *)(packet + 14); // Omitir cabecera Ethernet
    
    // Si detectamos tráfico saliendo de la IP sospechosa en Naucalpan
    std::cout << "[+] Paquete capturado de: " << inet_ntoa(ip_header->ip_src) << std::endl;
    
    // Análisis de firmas: ¿Intenta conectar a Windows Update o GitHub?
    // Esto confirmaría que es TU sistema operativo.
}

int main() {
    char errbuf[PCAP_ERRBUF_SIZE];
    pcap_t *handle = pcap_open_offline("~/nexus/evidence/capture.pcap", errbuf);

    if (handle == NULL) {
        std::cerr << "[!] Error al abrir el archivo .pcap: " << errbuf << std::endl;
        return 1;
    }

    std::cout << "[*] ANALIZANDO EVIDENCIA FORENSE EN EL MOTO E13..." << std::endl;
    pcap_loop(handle, 0, packet_handler, NULL);
    pcap_close(handle);

    return 0;
}
