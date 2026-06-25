#include <git2.h>
#include <iostream>

// Estructura para pasar el estado al callback
struct MyAuthPayload {
    const char* username;
    const char* password_or_token;
    int attempts = 0; // Contador de intentos
};

int my_cred_acquire_callback(
    git_credential **out,
    const char *url,
    const char *username_from_url,
    unsigned int allowed_types,
    void *payload) 
{
    MyAuthPayload* auth = static_cast<MyAuthPayload*>(payload);

    // IMPORTANTE: Si ya lo intentamos una vez, el servidor rechazó las credenciales.
    // Retornar un error detiene el bucle infinito y evita el error Http (34).
    if (auth->attempts > 0) {
        std::cerr << "Error: Credenciales rechazadas por el servidor para la URL: " << url << std::endl;
        return GIT_PASSTHROUGH; 
    }

    // Verificar si el servidor acepta autenticación por usuario/contraseña
    if (allowed_types & GIT_CREDENTIAL_USERPASS_PLAINTEXT) {
        auth->attempts++; // Incrementamos el contador
        
        // Creamos la credencial con el PAT o contraseña
        return git_credential_userpass_plaintext_new(
            out, 
            auth->username, 
            auth->password_or_token
        );
    }

    return GIT_PASSTHROUGH; // No soportamos el tipo de auth requerido
}

