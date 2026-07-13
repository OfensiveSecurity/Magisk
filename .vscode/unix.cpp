#include <iostream>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>

void lanzar_xfce_persistente() {
    pid_t pid;

    // 1. Primer fork
    pid = fork();

    if (pid < 0) {
        std::cerr << "Error al crear el primer fork." << std::endl;
        exit(EXIT_FAILURE);
    }

    // Si es el proceso padre, lo dejamos terminar de inmediato
    if (pid > 0) {
        return;
    }

    // 2. Convertir al hijo en líder de la sesión
    if (setsid() < 0) {
        exit(EXIT_FAILURE);
    }

    // 3. Segundo fork para garantizar la desvinculación de la terminal
    pid = fork();

    if (pid < 0) {
        exit(EXIT_FAILURE);
    }

    // El primer hijo termina aquí
    if (pid > 0) {
        exit(EXIT_SUCCESS);
    }

    // 4. Cambiar el directorio de trabajo para no bloquear ningún montaje
    chdir("/");

    // 5. Redirigir descriptores de archivos estándar a /dev/null
    int dev_null = open("/dev/null", O_RDWR);
    if (dev_null >= 0) {
        dup2(dev_null, STDIN_FILENO);
        dup2(dev_null, STDOUT_FILENO);
        dup2(dev_null, STDERR_FILENO);
        if (dev_null > 2) {
            close(dev_null);
        }
    }

    // 6. Configurar la variable de entorno y ejecutar XFCE
    // Configura DISPLAY=:2 para este proceso
    setenv("DISPLAY", ":2", 1);

    // Reemplaza el proceso actual con el script de inicio de XFCE
    // execl busca el ejecutable en el PATH, asegúrate de que startxfce4 sea accesible
    execlp("startxfce4", "startxfce4", nullptr);

    // Si execlp falla, el proceso termina de forma segura
    exit(EXIT_FAILURE);
}

int main() {
    std::cout << "Lanzando XFCE en background..." << std::endl;

    lanzar_xfce_persistente();

    std::cout << "El programa principal de C++ ya puede cerrarse de forma segura." << std::endl;
    std::cout << "XFCE seguirá corriendo en segundo plano." << std::endl;
