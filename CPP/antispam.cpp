#include <iostream>
#include <fstream>
#include <ctime>

void registrar_bloqueo(std::string numero) {
    std::ofstream log_file;
    // Abrimos en modo "append" para no borrar lo anterior
    log_file.open("/data/data/com.termux/files/home/registro_spam.log", std::ios_base::app);
    
    time_t ahora = time(0);
    char* dt = ctime(&ahora);
    
    log_file << "Bloqueado: " << numero << " | Fecha: " << dt;
    log_file.close();
}

// Llamamos a esta función dentro de tu lógica de bloqueo
