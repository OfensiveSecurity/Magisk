#include <stdio.h>
#include <stdlib.h>

// --- CONFIGURACIÓN DE GITHUB ---
#define GITHUB_TOKEN "TU_PERSONAL_ACCESS_TOKEN"
#define REPO_OWNER "akdmjeau-eng"
#define REPO_NAME "Magisk"

void actualizar_nexus() {
    printf("[*] Buscando actualizaciones en GitHub Actions...\n");

    char comando[1024];
    
    // Este comando de curl hace tres cosas:
    // 1. Se autentica con tu Token.
    // 2. Busca el último artefacto generado.
    // 3. Lo descarga con el nombre 'nexus_update.zip'.
    sprintf(comando, "curl -L -H \"Authorization: Bearer %s\" "
                     "-H \"Accept: application/vnd.github+json\" "
                     "https://api.github.com/repos/%s/%s/actions/artifacts > lista_artifacts.json",
                     GITHUB_TOKEN, REPO_OWNER, REPO_NAME);
    
    system(comando);
    printf("[+] Lista de artefactos obtenida. Listos para descargar el .apk\n");
}
