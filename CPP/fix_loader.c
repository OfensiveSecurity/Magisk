#include <unistd.h>
#include <sys/stat.h>
#include <stdio.h>

int main() {
    // Definimos las rutas exactas
    const char *target = "/usr/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2";
    const char *link_path = "/lib64/ld-linux-x86-64.so.2";

    printf("Intentando restaurar el cargador dinámico...\n");

    // Crear el directorio /lib64 por si no existe
    mkdir("/lib64", 0755);

    // Eliminar enlace roto si existe
    unlink(link_path);

    // Crear el enlace simbólico
    if (symlink(target, link_path) == 0) {
        printf("[EXITO] Enlace creado: %s\n", link_path);
        printf("Intenta ejecutar un comando ahora (ej. ls)\n");
    } else {
        perror("[ERROR] Fallo al crear el enlace");
        return 1;
    }

    return 0;
}
