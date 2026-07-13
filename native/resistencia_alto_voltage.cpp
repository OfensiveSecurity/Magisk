#include <iostream>
#include <iomanip>
#include <limits>

using namespace std;

void limpiarEntrada() {
    cin.clear();
    cin.ignore(numeric_limits<streamsize>::max(), '\n');
}

double leerNumero(const string& mensaje) {
    double valor;
    while (true) {
        cout << mensaje;
        if (cin >> valor && valor > 0) break;
        cout << "Valor invalido. Intenta de nuevo.\n";
        limpiarEntrada();
    }
    return valor;
}

int main() {
    cout << "=== Calculadora de Resistencia para Alto Voltaje ===\n\n";
    cout << "1. Conozco Voltaje y Corriente\n";
    cout << "2. Conozco Voltaje y Resistencia\n";
    cout << "3. Conozco Corriente y Resistencia\n";
    cout << "Opcion: ";

    int opcion;
    cin >> opcion;

    double V = 0, I = 0, R = 0, P = 0;

    switch (opcion) {
        case 1:
            V = leerNumero("Voltaje (V): ");
            I = leerNumero("Corriente (A): ");
            R = V / I;
            P = V * I;
            break;
        case 2:
            V = leerNumero("Voltaje (V): ");
            R = leerNumero("Resistencia (ohms): ");
            I = V / R;
            P = V * I;
            break;
        case 3:
            I = leerNumero("Corriente (A): ");
            R = leerNumero("Resistencia (ohms): ");
            V = I * R;
            P = I * I * R;
            break;
        default:
            cout << "Opcion invalida.\n";
            return 1;
    }

    cout << fixed << setprecision(4);
    cout << "\n--- Resultados ---\n";
    cout << "Voltaje:     " << V << " V\n";
    cout << "Corriente:   " << I << " A\n";
    cout << "Resistencia: " << R << " ohms\n";
    cout << "Potencia:    " << P << " W\n";

    // Recomendacion de vataje del resistor con margen de seguridad
    double vatajeRecomendado = P * 2.0; // factor de seguridad x2
    cout << "\nVataje minimo recomendado para el resistor: "
         << vatajeRecomendado << " W (incluye margen de seguridad x2)\n";

    if (V > 250) {
        cout << "\n[!] Advertencia: voltaje superior a 250V.\n";
        cout << "    Usa resistores con clasificacion de voltaje adecuada\n";
       cout << "    Usa resistores con clasificacion de voltaje adecuada\n";
        cout << "    y aislamiento apropiado para evitar arco electrico.\n";
    }

    return 0;
}