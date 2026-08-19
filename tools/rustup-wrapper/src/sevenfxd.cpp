#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>

int main() {
    // Creación de un socket básico para verificar la pila de red local
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        printf("Error al abrir el socket local.\n");
        return 1;
    }
    
    printf("Pila de red accesible en el espacio de usuario.\n");
    close(sock);
    return 0;
}
