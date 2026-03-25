#include <iostream>
#include <fstream>
#include <string>

// Simulación de lectura de sensores del Moto E13
std::string get_system_status() {
    return "ONLINE - Perímetro Seguro";
}

int main() {
    std::cout << "[*] INICIANDO PANEL WEB NEXUS EN PORT 8080..." << std::endl;
    
    // Generar el HTML dinámico para el navegador del móvil
    std::ofstream html("index.html");
    html << "<html><head><style>body{background:#000;color:#0f0;font-family:monospace;padding:20px;}"
         << ".alert{color:red;border:1px solid red;padding:10px;animation:blink 1s infinite;}"
         << "@keyframes blink{0%{opacity:1;}50%{opacity:0;}}</style></head><body>"
         << "<h1>NEXUS CORE - MONITOR V37.0</h1>"
         << "<p>STATUS: " << get_system_status() << "</p>"
         << "<h3>RADAR GEIGER: <span class='alert'>BUSCANDO MAC LAPTOP...</span></h3>"
         << "<ul><li>CPU: 38°C</li><li>RAM: 2.1GB LIBRE</li><li>TÚNEL SSH: ACTIVO</li></ul>"
         << "</body></html>";
    html.close();

    // Servir el archivo (Usando python para simplificar el hosting)
    system("python3 -m http.server 8080 &");
    return 0;
}
