#include <iostream>
#include <chrono>
#include <thread>
#include <string>
#include <iomanip>
using namespace std;
void limpiarPantalla() {
    #ifdef _WIN32
        system("cls");
    #else
        system("clear");
    #endif
}
void mostrarProgreso(const string& etapa, int duracionSegundos) {
    cout << "\n=== " << etapa << " ===" << endl;
    for (int i = 0; i <= 100; i += 5) {
        cout << "\r[" << string(i/5, '=') << string(20 - i/5, ' ') << "] "
             << setw(3) << i << "%" << flush;
        this_thread::sleep_for(chrono::milliseconds(duracionSegundos * 50));
    }
    cout << "\n✓ Etapa completada: " << etapa << endl;
}
int main() {
    limpiarPantalla();
    cout << "========================================\n";
    cout << "   SIMULADOR LAVADORA WHIRLPOOL\n";
    cout << "========================================\n\n";
    int opcion;
    cout << "Selecciona el ciclo de lavado:\n";
    cout << "1. Normal (Algodón)\n";
    cout << "2. Rápido 30 minutos\n";
    cout << "3. Delicados / Lencería\n";
    cout << "4. Enjuague + Centrifugado\n";
    cout << "5. Solo Centrifugado\n";                                                                                                               cout << "Opción: ";
    cin >> opcion;
    string ciclo;
    int duracionTotal = 0;
    switch(opcion) {
        case 1:
            ciclo = "Normal - Algodón";                                                                                                                     duracionTotal = 65;
            cout << "\nIniciando ciclo NORMAL (aprox. 65 minutos)\n";
            break;
        case 2:
            ciclo = "Rápido 30'";
            duracionTotal = 30;
            cout << "\nIniciando ciclo RÁPIDO 30 minutos\n";
            break;
        case 3:
            ciclo = "Delicados";
            duracionTotal = 45;
            cout << "\nIniciando ciclo DELICADOS\n";
            break;
        case 4:
            ciclo = "Enjuague + Centrifugado";
            duracionTotal = 20;
            cout << "\nIniciando ENJUAGUE + CENTRIFUGADO\n";
            break;
        case 5:
            ciclo = "Solo Centrifugado";
            duracionTotal = 8;
            cout << "\nIniciando SOLO CENTRIFUGADO\n";
            break;
        default:
            cout << "Opción inválida. Usando ciclo Normal.\n";
            ciclo = "Normal";
            duracionTotal = 65;
    }
    cout << "Cargando ropa... ";
    this_thread::sleep_for(chrono::seconds(2));
    cout << "Listo.\n";
    // Etapas del lavado
    if (opcion != 5) {
        mostrarProgreso("Llenado de agua", 3);
        mostrarProgreso("Lavado principal", opcion == 2 ? 8 : 15);

        if (opcion != 2) {
            mostrarProgreso("Enjuague 1", 4);
          mostrarProgreso("Enjuague 2", 4);
        } else {
            mostrarProgreso("Enjuague rápido", 5);
        }
    }
    mostrarProgreso("Centrifugado", opcion == 5 ? 8 : 6);
    cout << "\n========================================\n";
    cout << "¡Ciclo de lavado " << ciclo << " FINALIZADO!\n";
    cout << "La lavadora Whirlpool ha terminado correctamente.\n";
    cout << "Puedes retirar la ropa.\n";
    cout << "========================================\n";
    cout << "\nPresiona Enter para salir...";
    cin.ignore();
    cin.get();
    return 0;
}