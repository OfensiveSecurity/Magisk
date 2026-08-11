#include <iostream>
#include <unistd.h>
#include <sched.h>
#include <sys/wait.h>

int main() {
    std::cout << "UID original en el sistema: " << getuid() << std::endl;

    // Desasociar el espacio de usuario (User Namespace)
    // CLONE_NEWUSER permite crear un entorno donde el usuario actual puede ser mapeado>
    if (unshare(CLONE_NEWUSER) == -1) {
        std::perror("Error al ejecutar unshare");
        return 1;
    }

    // Dentro de este nuevo namespace, el UID interno cambia temporalmente a un estado >
    std::cout << "UID dentro del nuevo User Namespace: " << getuid() << std::endl;
    std::cout << "Entorno rootless inicializado con éxito." << std::endl;

    return 0;
}
