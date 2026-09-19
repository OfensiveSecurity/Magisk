#include <iostream>
#include <vector>
#include <openssl/evp.h>
#include <openssl/hmac.h>

// Ejemplo de verificación de integridad y autenticidad en el router del tanque
bool verificar_paquete_tactico(const std::vector<uint8_t>& datos_paquete,
                               const std::vector<uint8_t>& firma_recibida,
                               const std::vector<uint8_t>& clave_secreta) {
    unsigned int longitud_firma = 0;
    std::vector<uint8_t> firma_calculada(EVP_MAX_MD_SIZE);

    // Se calcula un MAC (Message Authentication Code) usando SHA-256
    HMAC(EVP_sha256(), clave_secreta.data(), clave_secreta.size(),
         datos_paquete.data(), datos_paquete.size(),
         firma_calculada.data(), &longitud_firma);

    // Comparación en tiempo constante para evitar ataques de canal lateral
    if (firma_recibida.size() != longitud_firma) return false;
    return CRYPTO_memcmp(firma_recibida.data(), firma_calculada.data(), longitud_firma)>
}