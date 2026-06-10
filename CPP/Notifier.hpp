#include <iostream>
#include <cstdlib> // Para system()

class Notifier {
public:
    static void avisarFinalizacion(int exitos, int fallos) {
        std::string mensaje = "Proceso terminado: " + std::to_string(exitos) + " exitos.";
        
        // 1. Alerta Sonora (Funciona en casi todas las terminales)
        // El caracter \a es el "Bell" de la terminal
        std::cout << "\a" << std::flush; 

        // 2. Alerta Visual (Ventana emergente)
#ifdef _WIN32
        // Comando para Windows (PowerShell)
        std::string cmd = "powershell -Command \"[Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('" + mensaje + "', 'Cipher Kernel')\"";
        system(cmd.c_str());
#elif __APPLE__
        // Comando para macOS (AppleScript)
        std::string cmd = "osascript -e 'display notification \"" + mensaje + "\" with title \"Cipher Kernel\"'";
        system(cmd.c_str());
#else
        // Comando para Linux (notify-send)
        std::string cmd = "notify-send 'Cipher Kernel' '" + mensaje + "'";
        system(cmd.c_str());
#endif
    }
};
// ... después de terminar el bucle de archivos ...
BatchProcessor::processDirectory(ruta, clave, cifrar);

// Obtenemos los contadores (puedes pasarlos como referencia o retorno)
Notifier::avisarFinalizacion(exitos, fallos);

std::cout << "Notificacion enviada." << std::endl;
