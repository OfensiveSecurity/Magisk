#include <iostream>
#include <string>
#include <memory>
#include <array>
#include <cstdlib>

// Función optimizada para ejecutar comandos del sistema sin generar warnings de atributos
std::string ejecutarComando(const char* cmd) {
    std::array<char, 128> buffer;
    std::string resultado;

    // Expresión lambda limpia para manejar el cierre del descriptor de archivo (pipe)
    auto deleterPipe = [](FILE* fp) { if (fp) pclose(fp); };

    // std::unique_ptr usando el tipo de la lambda para evitar el warning de decltype(&pclose)
    std::unique_ptr<FILE, decltype(deleterPipe)> pipe(popen(cmd, "r"), deleterPipe);

    if (!pipe) {
        return "[-] Error al ejecutar el comando interno.";
    }

    // Captura de la salida estándar línea por línea
    while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
        resultado += buffer.data();
    }
    return resultado;
}

int main() {
    std::cout << "==================================================" << std::endl;
    std::cout << "[+] DIAGNÓSTICO DE RED E INTERFACES INALÁMBRICAS" << std::endl;
    std::cout << "==================================================" << std::endl;

    // Ejemplo: Verificando extensiones inalámbricas (iwconfig)
    // Nota: Si no encuentra interfaces en modo monitor o inalámbricas, mostrará "no wireless extensions".
    std::cout << "\n[i] Ejecutando iwconfig..." << std::endl;
    std::string interfaces = ejecutarComando("iwconfig 2>&1");
    std::cout << interfaces << std::endl;

    // Ejemplo: Verificando sockets o conexiones activas (ss)
    std::cout << "\n[i] Monitoreando sockets activos rápidos (ss -tulpn)..." << std::endl;
    std::string sockets = ejecutarComando("ss -tulpn 2>&1");
    std::cout << sockets << std::endl;

    return 0;
}