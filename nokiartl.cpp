#include <iostream>
#include <vector>
#include <string>
#include <memory>                                                                                                                                                                #include <map>
#include <stdexcept>

// Definición de las VLANs estrictas según la arquitectura VICTORY
enum class VictoryVlan : uint16_t {
    SENSORES = 10,     // Cámaras, LiDAR, Radar
    ARMAMENTO = 20,    // Sistema de tiro, torreta, munición
    PROCESADOR_IA = 30 // Red de cómputo táctico y modelos de IA
};

// Estructura de una trama de red táctica encapsulada
struct TramaTactica {
    VictoryVlan vlan_id;
    std::string ip_origen;
    std::string ip_destino;
    std::vector<uint8_t> carga_util; // Datos binarios del paquete
};

// Clase que emula el Router de Red Seguro del Tanque
class RouterVictory {
private:
    // Matriz de permisos de enrutamiento (Zero-Trust)
    // Indica si una VLAN origen tiene permitido hablar directamente con una VLAN destino
    std::map<VictoryVlan, std::vector<VictoryVlan>> tabla_enrutamiento_permitido;

public:
    RouterVictory() {
        // Configuración inicial de aislamiento estricto:
        // Los sensores (10) PUEDEN enviar datos a la IA (30) para su procesamiento.
        tabla_enrutamiento_permitido[VictoryVlan::SENSORES] = { VictoryVlan::PROCESADOR_IA };

        // La IA (30) PUEDE enviar comandos al Armamento (20) tras validar amenazas.
        tabla_enrutamiento_permitido[VictoryVlan::PROCESADOR_IA] = { VictoryVlan::ARMAMENTO };

        // El Armamento (20) está aislado de la red de sensores públicos; NO puede recibir datos directos de ellos.
        tabla_enrutamiento_permitido[VictoryVlan::ARMAMENTO] = {};
    }

    // Procesa y conmuta la trama aplicando reglas estrictas de segmentación
    bool procesar_y_enrutar(const TramaTactica& trama, VictoryVlan vlan_destino_solicitada) {
        // 1. Verificación básica de seguridad: Evitar Spoofing (Falsificación de VLAN)
        if (trama.vlan_id != VictoryVlan::SENSORES &&
            trama.vlan_id != VictoryVlan::ARMAMENTO &&
            trama.vlan_id != VictoryVlan::PROCESADOR_IA) {
            std::cerr << "[ALERTA DE SEGURIDAD] Intento de inyección con VLAN inválida.\n";
            return false;
        }

        // 2. Si el tráfico es interno de la misma VLAN, se permite la conmutación de capa 2
        if (trama.vlan_id == vlan_destino_solicitada) {
            std::cout << "[INFO] Tráfico local permitido en VLAN " << static_cast<int>(trama.vlan_id) << "\n";
            return true;
        }

        // 3. Verificación de políticas entre dominios (Cross-Domain Enforcement)
        const auto& destinos_permitidos = tabla_enrutamiento_permitido[trama.vlan_id];
        for (const auto& vlan_valida : destinos_permitidos) {
            if (vlan_valida == vlan_destino_solicitada) {
                std::cout << "[ÉXITO] Trama enrutada de VLAN " << static_cast<int>(trama.vlan_id)
                          << " hacia VLAN " << static_cast<int>(vlan_destino_solicitada) << "\n";
                return true;
            }
        }

        // 4. Bloqueo por defecto (Default Drop)
        std::cerr << "[BLOQUEADO] Intento de violación de aislamiento VICTORY: VLAN "
                  << static_cast<int>(trama.vlan_id) << " intentó acceder a VLAN "
                  << static_cast<int>(vlan_destino_solicitada) << ".\n";
        return false;