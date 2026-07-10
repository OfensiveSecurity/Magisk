#include <iostream>
#include <thread>
#include <vector>

void send_request() {
    // Simula una petición HTTP rápida al dashboard
    system("curl -s http://localhost:8080 > /dev/null");
}

int main() {
    int concurrent_requests = 100; // Empezamos con 100 hilos
    std::vector<std::thread> threads;

    std::cout << "[!] INICIANDO STRESS TEST EN MOTO E13 (100 CONEXIONES)..." << std::endl;

    for (int i = 0; i < concurrent_requests; ++i) {
        threads.push_back(std::thread(send_request));
    }

    for (auto& th : threads) {
        th.join();
    }

    std::cout << "[✓] Test completado. Revisa la temperatura del procesador." << std::endl;
    return 0;
}
