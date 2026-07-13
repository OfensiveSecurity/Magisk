#include <iostream>
#include <vector>
#include <string>
#include <cstring>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <thread>
#include <mutex>

const std::string TARGET_IP = "192.168.1.254";
std::mutex cout_mutex;

// Common router management ports
const std::vector<int> COMMON_PORTS = {21, 22, 23, 80, 443, 8080, 8443};

void check_port(std::string ip, int port) {
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) return;

    // Set a strict 2-second timeout so we don't hang indefinitely
    struct timeval timeout;
    timeout.tv_sec = 2;
    timeout.tv_usec = 0;
    setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));
    setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout));

    sockaddr_in server_addr;
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    inet_pton(AF_INET, ip.c_str(), &server_addr.sin_addr);

    // Attempt connection
    if (connect(sock, (struct sockaddr*)&server_addr, sizeof(server_addr)) == 0) {
        std::lock_guard<std::mutex> lock(cout_mutex);
        std::cout << "[+] Port " << port << " is OPEN on " << ip << "\n";

        // Attempt a safe banner grab
        char buffer[1024];
        std::memset(buffer, 0, sizeof(buffer));

        // Give the service 500ms to send a banner (common for SSH/FTP)
        int bytes_received = recv(sock, buffer, sizeof(buffer) - 1, 0);
        if (bytes_received > 0) {
            std::cout << "    |--> Banner: " << std::string(buffer) << "\n";
        } else {
            std::cout << "    |--> No immediate banner returned (likely HTTP/HTTPS).\n";
        }
    }

    close(sock);
}

int main() {
    std::cout << "[*] Starting safe service mapping for " << TARGET_IP << "...\n";
    std::vector<std::thread> threads;

    // Spawn a thread per port for efficient, concurrent scanning
    for (int port : COMMON_PORTS) {
        threads.emplace_back(check_port, TARGET_IP, port);
    }

    // Join threads
    for (auto& th : threads) {
        if (th.joinable()) {
            th.join();
        }
    }

    std::cout << "[*] Scan complete.\n";
    return 0;
}