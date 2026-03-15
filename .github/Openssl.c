#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int verificar_sha256(const char* archivo, const char* hash_esperado) {
    char comando[256];
    char resultado[128];
    
    // Comando para obtener solo el hash
    sprintf(comando, "sha256sum %s | cut -d' ' -f1", archivo);
    
    FILE* pipe = popen(comando, "r");
    if (!pipe) return 0;

    if (fgets(resultado, sizeof(resultado), pipe) != NULL) {
        // Eliminar salto de línea
        resultado[strcspn(resultado, "\n")] = 0;
        pclose(pipe);
        return strcmp(resultado, hash_esperado) == 0;
    }
    
    pclose(pipe);
    return 0;
}
