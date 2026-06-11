#include <iostream>
#include <unistd.h>

void create_secure_backup() {
    std::cout << "[*] INICIANDO ENCRIPTACIÓN DEL NEXUS CORE..." << std::endl;

    // 1. Comprimir carpeta de herramientas y logs
    system("tar -czf nexus_backup.tar.gz ~/nexus/bin ~/nexus/logs");

    // 2. Cifrar con OpenSSL (AES-256-CBC)
    // Se te pedirá una contraseña robusta en la terminal
    system("openssl enc -aes-256-cbc -salt -in nexus_backup.tar.gz -out nexus_vault.enc");

    // 3. Limpiar el archivo temporal sin cifrar
    system("shred -u nexus_backup.tar.gz");

    std::cout << "[✓] Cápsula 'nexus_vault.enc' lista para subir a GitHub." << std::endl;
}

int main() {
    create_secure_backup();
    return 0;
}
