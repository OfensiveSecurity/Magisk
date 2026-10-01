#include <iostream>
#include <string>
#include <vector>
#include <cstdlib>
#include <memory>
#include <stdexcept>
#include <array>

// Estructura para almacenar el estado del entorno de automatización
struct EntornoValidacion {
    bool interfazValida;
    std::string tokenEstado;
    int codigoRetorno;
};

class GestorAutomatizacion {
private:
    std::vector<std::string> interfacesPermitidas;

public:
    GestorAutomatizacion() {
        // Lista blanca de interfaces de red seguras autorizadas para operar
        interfacesPermitidas = {"wlan0", "wlan0mon", "tun0", "lo", "eth0"};
    }

    // Valida si la interfaz solicitada está dentro de la política permitida
    bool verificarInterfaz(const std::string& interfaz) {
        for (const auto& iface : interfacesPermitidas) {
            if (interfaz == iface) {
                return true;
            }
        }
        return false;
    }

    // Lee de forma segura variables de entorno del sistema (como configuraciones de CI/CD)
    std::string obtenerVariableEntorno(const std::string& clave) {
        // Uso seguro de getenv evaluando la existencia previa del puntero
        const char* valorRaw = std::getenv(clave.c_str());
        if (!valorRaw) {
            return "";
        }
        // Conversión inmediata a objeto std::string seguro
        return std::string(valorRaw);
    }

    // Ejecuta de forma controlada consultas de estado del sistema (Solo lectura)
    std::string verificarEstadoSistema() {
        std::array<char, 128> buffer;
        std::string resultado;
        
        // Uso de popen únicamente para comandos estáticos del sistema sin concatenación de variables de usuario
        std::unique_ptr<FILE, decltype(&pclose)> pipe(popen("uname -r", "r"), pclose);
        if (!pipe) {
            throw std::runtime_error("[-] Fallo al inicializar la verificación del sistema.");
        }
        
        while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
            resultado += buffer.data();
        }
        return resultado;
    }
};

int main() {
    std::cout << "===========================================" << std::endl;
    std::cout << "   Verificador de Integridad en C++ (CI/CD) " << std::endl;
    std::cout << "===========================================" << std::endl;

    GestorAutomatizacion gestor;

    // 1. Validación de Interfaces de Red
    std::string interfazPrueba = "wlan0mon";
    std::cout << "[*] Validando interfaz: " << interfazPrueba << "..." << std::endl;
    
    if (gestor.verificarInterfaz(interfazPrueba)) {
        std::cout << "[+] Interfaz autorizada para el despliegue de políticas." << std::endl;
    } else {
        std::cerr << "[-] Alerta: Interfaz no permitida por la política de seguridad." << std::endl;
    }

    // 2. Extracción segura de parámetros de entorno
    std::string tokenSujeto = gestor.obtenerVariableEntorno("USER");
    if (!tokenSujeto.empty()) {
        std::cout << "[+] Contexto de ejecución detectado (Usuario): " << tokenSujeto << std::endl;
    }

    // 3. Consulta de parámetros del Kernel anfitrión
    try {
        std::string kernelVer = gestor.verificarEstadoSistema();
        std::cout << "[+] Versión del núcleo del sistema: " << kernelVer;
    } catch (const std::exception& e) {
        std::cerr << e.what() << std::endl;
    }

    return 0;
}
