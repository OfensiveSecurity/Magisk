#include <iostream>
#include <string>
#include <chrono>
#include <thread>

// Clase para gestionar la alimentación y el soporte físico
class PowerSupport {
private:
    float batteryVoltage;
    float chargerVoltage;
    bool isCannedShielded; // Representa la protección de la "lata"

public:
    PowerSupport(float batt, float charger, bool shield)
        : batteryVoltage(batt), chargerVoltage(charger), isCannedShielded(shield) {}

    void checkStability() {
        std::cout << "[Energía] Voltaje de Pila: " << batteryVoltage << "V" << std::endl;
        if (batteryVoltage < 7.0) {
            std::cout << "[Alerta] Pila por debajo del umbral nominal." << std::endl;
        }
        if (isCannedShielded) {
            std::cout << "[Hardware] Aislamiento en chasis de lata activo (HDI Ready)." << std::endl;
        }
    }
};

// Clase para la conexión de fibra y red
class NetworkNode {
private:
    int opticalLoss; // en dB
    std::string routerIP;

public:
    NetworkNode(int loss, std::string ip) : opticalLoss(loss), routerIP(ip) {}

    void verifyLink() {
        std::cout << "[Fibra] Nivel de señal: " << opticalLoss << " dB" << std::endl;
        if (opticalLoss <= -6) {
            std::cout << "[Link] Conexión estable en Router Huawei (" << routerIP << ")" << std::endl;
        } else {
            std::cout << "[Link] Pérdida de señal crítica." << std::endl;
        }
    }
};

int main() {
    // Inicialización del sistema con tus parámetros:
    // Pila 7V, Cargador (5V aprox), Protección de lata, -6dB Fibra, Router Huawei
    PowerSupport soporte(7.0f, 5.2f, true);
    NetworkNode huaweiRouter(-6, "192.168.1.1");

    std::cout << "--- Iniciando Sistema de Soporte Nexus ---" << std::endl;

    while (true) {
        soporte.checkStability();
        huaweiRouter.verifyLink();

        std::cout << "------------------------------------------" << std::endl;
        // Delay para evitar saturación de logs
        std::this_thread::sleep_for(std::chrono::seconds(5));
    }

    return 0;
}