#include <windows.h>
#include <iostream>

// 1. Definir un identificador de mensaje personalizado para Windows
// WM_USER es el punto de partida seguro para mensajes privados de la aplicación
const UINT WM_REALTIME_SIGNAL_2 = WM_USER + 2;

int main() {
    // Obtener el ID del hilo actual (el receptor)
    DWORD idHiloReceptor = GetCurrentThreadId();
    
    std::cout << "ID del Hilo actual: " << idHiloReceptor << std::endl;
    std::cout << "Simulando Signal 2 en Windows mediante PostThreadMessage..." << std::endl;

    // 2. Preparar los datos adjuntos (Carga útil equivalente a sigval)
    // En Windows pasamos datos mediante WPARAM y LPARAM
    WPARAM datosAdjuntos = 2026; 

    std::cout << "[Emisor] Enviando mensaje con el dato: " << datosAdjuntos << "..." << std::endl;

    // 3. Enviar el mensaje de forma asíncrona al hilo (Equivalente a sigqueue)
    if (!PostThreadMessage(idHiloReceptor, WM_REALTIME_SIGNAL_2, datosAdjuntos, 0)) {
        std::cerr << "Error al enviar el mensaje. Código: " << GetLastError() << std::endl;
        return 1;
    }

    // 4. Bucle de mensajes (Equivalente al receptor / Signal Handler)
    MSG msg;
    std::cout << "[Receptor] Esperando el mensaje en el bucle..." << std::endl;
    
    // Captura los mensajes que llegan a este hilo de ejecución
    while (GetMessage(&msg, NULL, 0, 0)) {
        if (msg.message == WM_REALTIME_SIGNAL_2) {
            std::cout << "\n[Receptor] ¡Mensaje equivalente a Signal 2 recibido!" << std::endl;
            
            // Extraer el dato adjunto que viajó en el parámetro wParam
            int valor_recibido = static_cast<int>(msg.wParam);
            std::cout << "[Receptor] Datos adjuntos recibidos: " << valor_recibido << std::endl;
            
            break; // Romper el bucle para terminar el programa de ejemplo
        }
        
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    std::cout << "[Main] Programa terminado con éxito en Windows." << std::endl;
    return 0;
}
