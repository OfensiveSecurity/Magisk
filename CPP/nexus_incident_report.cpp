#include <iostream>
#include <fstream>
#include <string>
#include <ctime>

// Datos del Incidente (Marzo 2026)
const std::string DEVICE_ID = "Motorola Moto E13 - Nexus Node 01";
const std::string LOCATION_LOCK = "Naucalpan de Juárez, EdoMex";

void generateForensicLog() {
    std::ofstream report("NEXUS_INCIDENT_REPORT.txt");
    
    // Obtener Timestamp
    time_t now = time(0);
    char* dt = ctime(&now);

    report << "================================================" << std::endl;
    report << "   REPORTE TÉCNICO DE INCIDENTE - NEXUS CORE    " << std::endl;
    report << "================================================" << std::endl;
    report << "FECHA/HORA: " << dt;
    report << "DISPOSITIVO DE ORIGEN: " << DEVICE_ID << std::endl;
    report << "UBICACIÓN REGISTRADA: " << LOCATION_LOCK << std::endl;
    report << "------------------------------------------------" << std::endl;
    
    report << "[!] HARDWARE SUSTRAÍDO:" << std::endl;
    report << "- PC de Escritorio (Estación de Trabajo PEN-200)" << std::endl;
    report << "- Laptop de Campo (Nexus Dashboard Mobile)" << std::endl;
    report << "- Antena WiFi Externa (Modo Monitor Activo)" << std::endl;
    report << "------------------------------------------------" << std::endl;

    report << "[+] ESTADO DE SEGURIDAD (MOTO E13):" << std::endl;
    report << "- Cuentas GitHub (akdmjeau-eng): BLOQUEADAS" << std::endl;
    report << "- Binance Security Protocol: ACTIVO (IP México Only)" << std::endl;
    report << "- Cloud-Sync: Respaldado y Cifrado con GPG" << std::endl;
    report << "------------------------------------------------" << std::endl;

    report << "[*] ÚLTIMA SEÑAL DE HARDWARE (WARDRIVE):" << std::endl;
    report << "Buscando MACs vinculadas en el sector Naucalpan..." << std::endl;
    
    report.close();
    std::cout << "[✓] Reporte generado: NEXUS_INCIDENT_REPORT.txt" << std::endl;
}

int main() {
    system("clear");
    std::cout << "[*] Compilando bitácora de incidentes forenses..." << std::endl;
    generateForensicLog();
    return 0;
}
