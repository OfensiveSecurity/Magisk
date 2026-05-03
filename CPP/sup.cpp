#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Función para ejecutar comandos de red con privilegios
void ejecutar_comando_red(char* mac_objetivo) {
    char comando[256];
    
    printf("Configurando seguridad en la puerta de enlace 192.168.100.1...\n");

    // Ejemplo usando curl para enviar una instrucción al panel del módem
    // NOTA: Los parámetros 'mac_filter' varían según el modelo del firmware
    sprintf(comando, "curl -u root:admin -X POST -d \"enable_filter=1&block_mac=%s\" http://192.168.100.1/save_config.cgi", mac_objetivo);
    
    int status = system(comando);

    if (status == 0) {
        printf("Éxito: La dirección MAC %s ha sido procesada.\n", mac_objetivo);
    } else {
        printf("Error al conectar con el módem.\n");
    }
}

int main() {
    // Aquí pondrías la MAC de alguien que esté "bajando" tu conexión
    char* mac_intrusa = "00:1A:2B:3C:4D:5E"; 
    
    ejecutar_comando_red(mac_intrusa);
    
    return 0;
}
