#include <stdint.h>

class Telemetria {
private:
    // Dirección base del USART1 (verificar en el mapa de memoria del PDF)
    static constexpr uint32_t USART1_BASE = 0x40011000;
    
    struct UART_Regs {
        volatile uint32_t CR1;
        volatile uint32_t CR2;
        volatile uint32_t CR3;
        volatile uint32_t BRR;
        uint32_t reserved[2];
        volatile uint32_t ISR;
        volatile uint32_t TDR;
    };

    static UART_Regs* const uart;

public:
    static void inicializar(uint32_t baudios) {
        // 1. Habilitar reloj del USART (en el registro RCC)
        // 2. Configurar baudios (asumiendo 144MHz de reloj de bus)
        uart->BRR = 144000000 / baudios;
        // 3. Habilitar Transmisor y UART (TE y UE)
        uart->CR1 |= (1 << 3) | (1 << 0);
    }

    static void enviar_mensaje(const char* str) {
        while (*str) {
            // Esperar a que el registro de transmisión esté vacío (TXE)
            while (!(uart->ISR & (1 << 7)));
            uart->TDR = *str++;
        }
    }
};

// Definición del puntero a registros
Telemetria::UART_Regs* const Telemetria::uart = (Telemetria::UART_Regs*)USART1_BASE;
