#include <vector>
#include <cstdint>

class Compressor {
public:
    // Comprime: Transforma "AAAABBC" en "4A2B1C"
    static std::vector<uint8_t> compress(const std::vector<uint8_t>& data) {
        std::vector<uint8_t> result;
        for (size_t i = 0; i < data.size(); ++i) {
            uint8_t count = 1;
            while (i + 1 < data.size() && data[i] == data[i + 1] && count < 255) {
                count++;
                i++;
            }
            result.push_back(count);
            result.push_back(data[i]);
        }
        return result;
    }

    // Descomprime: Transforma "4A2B1C" de vuelta a "AAAABBC"
    static std::vector<uint8_t> decompress(const std::vector<uint8_t>& data) {
        std::vector<uint8_t> result;
        for (size_t i = 0; i < data.size(); i += 2) {
            if (i + 1 < data.size()) {
                uint8_t count = data[i];
                uint8_t value = data[i + 1];
                for (int j = 0; j < count; ++j) {
                    result.push_back(value);
                }
            }
        }
        return result;
    }
};
void procesarArchivoCompleto(const std::string& entrada, const std::string& salida, const std::string& clave, bool cifrar) {
    // ... (Código anterior de apertura de archivos y checkClave) ...

    if (cifrar) {
        std::vector<uint8_t> original = leerArchivo(entrada);
        
        // PASO 1: Comprimir
        std::vector<uint8_t> comprimido = Compressor::compress(original);
        
        // PASO 2: Cifrar
        kernel.setKey(clave);
        kernel.process(comprimido);

        // Guardar con la cabecera (Sello + Checksum)
        std::ofstream fOut(salida, std::ios::binary);
        fOut.write(reinterpret_cast<char*>(&sello), 4);
        fOut.write(reinterpret_cast<char*>(&checkClave), 4);
        fOut.write(reinterpret_cast<char*>(comprimido.data()), comprimido.size());
    } 
    else {
        // ... (Lectura de cabecera y verificación de clave) ...

        std::vector<uint8_t> buffer((std::istreambuf_iterator<char>(fIn)), std::istreambuf_iterator<char>());
        
        // PASO 1: Descifrar
        kernel.setKey(clave);
        kernel.process(buffer);

        // PASO 2: Descomprimir
        std::vector<uint8_t> original = Compressor::decompress(buffer);
        
        guardarArchivo(salida, original);
    }
}
