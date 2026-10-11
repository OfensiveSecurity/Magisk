
#include <iostream>
#include <string>

struct EstadoLavadora {
    bool aguaAlta = true;
    bool tapaBloqueada = true;
    bool motorZumbando = true;
    bool tinaGira = false;
    bool golpes = true;
    bool drenajeObstruido = true;
};

void diagnosticar(const EstadoLavadora& e) {
    std::cout << "\n=== PALL | Whirlpool 8MWTW1813MJM ===\n";

    if (e.aguaAlta || e.golpes || e.motorZumbando) {
        std::cout
            << "[ALERTA] No iniciar centrifugado.\n"
            << "Mantener el equipo desconectado.\n";
    }

    if (e.drenajeObstruido) {
        std::cout
            << "[REVISION] Comprobar manguera y drenaje.\n";
    }

    if (e.tapaBloqueada) {
        std::cout
            << "[SEGURIDAD] No puentear el bloqueo.\n";
    }

    if (!e.tinaGira && e.motorZumbando) {
        std::cout
            << "[REVISION] Investigar accionamiento "
            << "y transmision con tecnico.\n";
    }

    std::cout
        << "[PALL] Diagnostico terminado; "
        << "ningun componente fue accionado.\n";
}

int main() {
    const EstadoLavadora estado;
    diagnosticar(estado);
    return 0;
}