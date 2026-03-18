#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Función para ejecutar comandos de Git y capturar el estado
int execute_git_merge(const char *branch_name) {
    char command[256];
    snprintf(command, sizeof(command), "git merge %s", branch_name);
    
    printf("[C-ENGINE] Intentando fusión de rama: %s\n", branch_name);
    int status = system(command);
    
    if (status != 0) {
        printf("[C-ENGINE] Conflicto detectado. Llamando al depurador de Python...\n");
        return 1; // Retorna error para activar el script de Python
    }
    
    printf("[C-ENGINE] Fusión completada con éxito.\n");
    return 0;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Uso: %s <nombre_de_rama>\n", argv[0]);
        return 1;
    }
    
    if (execute_git_merge(argv[1]) == 1) {
        // Ejecuta el depurador de Python si el comando de C detecta conflicto
        system("python3 nexus_debugger.py");
    }
    
    return 0;
}
