#include <iostream>
#include <thread>
#include <chrono>
enum class Estado {
    ENJUAGUE,
    CENTRIFUGADO,
    ERROR,
    FINALIZADO
};
class MotorLavadora {
public:
    void enjuagar() {
        std::cout << "\n=== ENJUAGUE ===\n";
        for (int i = 0; i < 5; i++) {
            std::cout << "Motor gira a la derecha\n";
            esperar(1);
            std::cout << "Motor gira a la izquierda\n";
            esperar(1);
        }
        std::cout << "Enjuague completado.\n";
    }
    bool centrifugadoCorrecto() {
        static int intento = 0;
        intento++;
        std::cout << "Verificando sensores...\n";
        if (intento < 3) {
            std::cout << "Fallo detectado.\n";
            return false;
        }
        return true;
    }
    bool exprimir() {
        std::cout << "\n=== CENTRIFUGADO ===\n";

        for (int velocidad = 200; velocidad <= 1200; velocidad += 200) {
            std::cout << "Velocidad: " << velocidad << " RPM\n";
            esperar(1);
        }
        return centrifugadoCorrecto();
    }
private:
    void esperar(int segundos) {
        std::this_thread::sleep_for(
            std::chrono::seconds(segundos)
        );
    }
};
int main() {
    MotorLavadora motor;
    Estado estado = Estado::ENJUAGUE;
    int intentos = 0;
    const int maxIntentos = 3;
    while (estado != Estado::FINALIZADO) {
        switch (estado) {
        case Estado::ENJUAGUE:
            motor.enjuagar();
            estado = Estado::CENTRIFUGADO;
            break;
        case Estado::CENTRIFUGADO:
            if (motor.exprimir()) {
                std::cout
                    << "Centrifugado correcto.\n";
                estado = Estado::FINALIZADO;
            } else {
                intentos++;
                std::cout
                    << "Intento fallido #"
                    << intentos << "\n";
                if (intentos >= maxIntentos) {
                    estado = Estado::ERROR;
                } else {
                    estado = Estado::ENJUAGUE;
                }
            }
            break;
        case Estado::ERROR:
            std::cout
                << "\nERROR: No fue posible completar "
                << "el centrifugado.\n";
