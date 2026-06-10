#include <iostream>
#include <fstream>
#include <string>
#include <chrono>
#include <ctime>

class Logger {
public:
    static void log(const std::string& mensaje, bool esError = false) {
        std::ofstream archivoLog("reporte_proceso.log", std::ios::app);
        if (!archivoLog.is_open()) return;

        // Obtener tiempo actual
        auto ahora = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
        std::string tiempo = std::ctime(&ahora);
        tiempo.pop_back(); // Quitar el salto de línea de ctime

        std::string etiqueta = esError ? "[ERROR] " : "[OK]    ";
        
        archivoLog << "[" << tiempo << "] " << etiqueta << mensaje << std::endl;
        archivoLog.close();
    }

    static void iniciarSesion() {
        std::ofstream archivoLog("reporte_proceso.log", std::ios::app);
        archivoLog << "\n================ INICIO DE SESION ================\n";
    }
};
static void processDirectory(const std::string& ruta, const std::string& clave, bool cifrar) {
    Logger::iniciarSesion();
    int exitos = 0, fallos = 0;

    for (const auto& entrada : fs::directory_iterator(ruta)) {
        try {
            if (fs::is_regular_file(entrada.path())) {
                // ... lógica de nombres de archivos ...

                // Llamada al kernel (ejemplo simplificado)
                procesarArchivoCompleto(archivoOriginal, archivoDestino, clave, cifrar);
                
                Logger::log("Procesado: " + entrada.path().filename().string());
                exitos++;
            }
        } catch (const std::exception& e) {
            Logger::log("Fallo en " + entrada.path().filename().string() + ": " + e.what(), true);
            fallos++;
        }
    }

    Logger::log("Resumen: " + std::to_string(exitos) + " exitos, " + std::to_string(fallos) + " fallos.");
}
