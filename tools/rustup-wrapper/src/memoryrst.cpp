#include <iostream>
#include <string_view>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <sys/stat.h>

class MassiveMemoryArray {
private:
    int m_fileDescriptor;
    uint8_t* m_mappedRegion;
    size_t m_allocatedSize;

public:
    // Define el tamaño del bloque virtual (ej. 1 Gigabyte para la demostración estructural)
    explicit MassiveMemoryArray(std::string_view backingFile, size_t arraySize) 
        : m_fileDescriptor(-1), m_mappedRegion(nullptr), m_allocatedSize(arraySize) {
        
        // 1. Abrir o crear el archivo de respaldo con permisos de lectura y escritura
        m_fileDescriptor = open(backingFile.data(), O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
        if (m_fileDescriptor < 0) {
            perror("[Memory] Error al abrir el archivo de respaldo");
            return;
        }

        // 2. Ajustar el tamaño físico del archivo en el sistema de almacenamiento
        if (ftruncate(m_fileDescriptor, m_allocatedSize) < 0) {
            perror("[Memory] Error al truncar el tamaño del archivo");
            close(m_fileDescriptor);
            m_fileDescriptor = -1;
            return;
        }

        // 3. Proyectar el archivo directamente en la memoria virtual del proceso
        m_mappedRegion = static_cast<uint8_t*>(mmap(
            nullptr, 
            m_allocatedSize, 
            PROT_READ | PROT_WRITE, 
            MAP_SHARED, 
            m_fileDescriptor, 
            0
        ));

        if (m_mappedRegion == MAP_FAILED) {
            perror("[Memory] Error al ejecutar mmap");
            m_mappedRegion = nullptr;
            close(m_fileDescriptor);
            m_fileDescriptor = -1;
        } else {
            std::cout << "[Memory] Bloque masivo proyectado en la direccion: " 
                      << static_cast<void*>(m_mappedRegion) << " (" << m_allocatedSize << " bytes).\n";
        }
    }

    ~MassiveMemoryArray() {
        if (m_mappedRegion) {
            // Sincronizar y desmapear la región de memoria virtual antes de cerrar
            msync(m_mappedRegion, m_allocatedSize, MS_SYNC);
            munmap(m_mappedRegion, m_allocatedSize);
        }
        if (m_fileDescriptor >= 0) {
            close(m_fileDescriptor);
        }
        std::cout << "[Memory] Recursos de asignacion masiva liberados de manera segura.\n";
    }

    // Métodos de acceso rápido mediante aritmética de punteros (Thread-Safe si no se solapan índices)
    void writeByte(size_t index, uint8_t value) {
        if (index < m_allocatedSize && m_mappedRegion) {
            m_mappedRegion[index] = value;
        }
    }

    uint8_t readByte(size_t index) const {
        if (index < m_allocatedSize && m_mappedRegion) {
            return m_mappedRegion[index];
        }
        return 0;
    }
};

int main() {
    size_t gigabyteSize = 1024ULL * 1024ULL * 1024ULL; // 1 GB virtual
    
    {
        MassiveMemoryArray massiveBlock("session_backing.dat", gigabyteSize);
        
        // Escritura de control en índices extremos de la estructura sin saturar la RAM física
        massiveBlock.writeByte(0, 0xAA);
        massiveBlock.writeByte(gigabyteSize - 1, 0xFF);
        
        std::cout << "[Main] Verificacion de lectura en indice inicial: " 
                  << std::hex << static_cast<int>(massiveBlock.readByte(0)) << std::endl;
    } // El objeto sale de ámbito aquí y libera la proyección de forma segura.

    // Limpieza opcional del archivo físico generado
    unlink("session_backing.dat");
    return 0;
}
