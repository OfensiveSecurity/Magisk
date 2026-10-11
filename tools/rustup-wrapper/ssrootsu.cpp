#include <iostream>
#include <string>
#include <string_view>
#include <vector>
#include <memory>
#include <array>

class SubprocessBridge {
public:
    // Ejecuta un comando y procesa su salida en tiempo real mediante un callback
    static bool streamStdout(std::string_view command, const auto& lineCallback) {
        // Redirigir stderr a stdout (2>&1) asegura capturar flujos de error de herramientas como ADB/Fastboot
        std::string fullCommand = std::string(command) + " 2>&1";
        
        // Abrir tubería de lectura de flujo de bytes
        std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(fullCommand.c_str(), "r"), pclose);
        
        if (!pipe) {
            std::cerr << "[Bridge] Error critico al abrir la tuberia del sistema.\n";
            return false;
        }

        std::array<char, 256> buffer;
        std::string currentLine;

        // Leer el flujo de salida mientras el proceso siga emitiendo datos
        while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
            for (char ch : buffer) {
                if (ch == '\0') break;
                if (ch == '\n') {
                    if (!currentLine.empty()) {
                        lineCallback(currentLine);
                        currentLine.clear();
                    }
                } else {
                    currentLine += ch;
                }
            }
        }
        
        // Enviar residuo si la última línea no terminó con un salto de página
        if (!currentLine.empty()) {
            lineCallback(currentLine);
        }

        return true;
    }
};

int main() {
    std::cout << "[Main] Iniciando monitoreo de dispositivos conectados...\n";
    
    // Automatización conceptual: Equivalente a invocar comandos de infraestructura como "adb devices"
    std::string command = "adb devices";
    
    auto printCallback = [](const std::string& line) {
        std::cout << " -> [Stream OUT]: " << line << "\n";
    };

    bool success = SubprocessBridge::streamStdout(command, printCallback);
    std::cout << "[Main] Proceso terminado con estado: " << (success ? "Exito" : "Fallo") << "\n";

    return 0;
}
