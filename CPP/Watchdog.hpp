#include <stdint.h>

class Watchdog {
private:
    // Direcciones base según el mapa de memoria del Cortex-M33
    static constexpr uint32_t IWDG_BASE = 0x40003000;
    
    struct IWDG_Regs {
        volatile uint32_t KR;  // Key Register
        volatile uint32_t PR;  // Prescaler Register
        volatile uint32_t RLR; // Reload Register
        volatile uint32_t SR;  // Status Register
    };

    static IWDG_Regs* const iwdg;

public:
    static void iniciar(uint16_t milisegundos) {
        iwdg->KR = 0x5555;      // Habilitar acceso a los registros PR y RLR
        iwdg->PR = 0x03;        // Prescaler de 64 (reloj de ~32kHz / 64 = 500Hz)
        iwdg->RLR = milisegundos; // Configurar el tiempo de desbordamiento
        iwdg->KR = 0xCCCC;      // Iniciar el Watchdog
    }

    static void alimentar() {
        iwdg->KR = 0xAAAA;      // "Patear el perro" (resetear la cuenta)
    }
};

// Instancia del puntero al hardware
Watchdog::IWDG_Regs* const Watchdog::iwdg = (Watchdog::IWDG_Regs*)IWDG_BASE;
extern "C" void main_cpp() {
    // Iniciamos el Watchdog con un margen de 1 segundo
    Watchdog::iniciar(1000); 
    
    while(1) {
        // 1. Recibir datos (Posible punto de ataque de Fuzzing)
        // 2. Procesar con IA
        
        // 3. Si todo salió bien, alimentamos al Watchdog
        Watchdog::alimentar();
        
        // Si el procesamiento se bloquea por un ataque, 
        // el Watchdog reiniciará el sistema en 1000ms.
    }
}

