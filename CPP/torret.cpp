#include <cmath>

struct TelemetriaTanque {
    double velocidad_nodos;
    double azimuth_torreta;
    double distancia_obstaculo; // Enviado al módulo de IA
};

class FiltroSeguridadIA {
public:
    // Filtra lecturas físicamente imposibles generadas por interferencia o hackeo
    bool es_lectura_valida(const TelemetriaTanque& datos) {
        // Un tanque no puede viajar a 300 km/h, ni el azimut superar los 360 grados
        if (datos.velocidad_nodos < 0.0 || datos.velocidad_nodos > 45.0) return false;
        if (datos.azimuth_torreta < 0.0 || datos.azimuth_torreta > 360.0) return false;
        if (std::isnan(datos.distancia_obstaculo) || datos.distancia_obstaculo < 0.0) return false;

        return true;
    }
};

