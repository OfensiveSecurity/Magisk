#include <iostream>
#include <fstream>
#include <string>

// Configuración del Receptor (Tu Moto E13 en Naucalpan)
const std::string LISTENER_IP = "tu_ip_mexico_motoe13"; 
const std::string LOG_FILE = "target_caught.log";

void sendAlert() {
    std::cout << "[!] ACCESO NO AUTORIZADO DETECTADO." << std::endl;
    // Comando para enviar IP, Geolocalización y Nombre de Red del ladrón
    std::string alert_cmd = "curl -s -X POST http://" + LISTENER_IP + ":8080/alert -d 'status=INTRUSION_DETECTED&loc=NAUCALPAN_SECTOR_4'";
    system(alert_cmd.c_str());
}

int main() {
    // El archivo parece un bloc de notas, pero es un binario de rastreo
    std::ofstream fakeFile("passwords_binance.txt");
    fakeFile << "User: akdmjeau-eng\nPass: ************ (Click para ver)";
    fakeFile.close();

    // Si alguien intenta leer o ejecutar procesos sobre este archivo:
    sendAlert();

    return 0;
}
