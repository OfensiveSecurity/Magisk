#include <iostream>
#include <string_view>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <cstring>

// Estructura de datos fija que compartiran los procesos
struct SharedNetworkState {
    uint32_t activeNetworkCount;
    char primaryInterface[16];
    bool isInterfaceLocked;
};

class SharedMemorySegment {
private:
    std::string m_segmentName;
    size_t m_size;
    int m_shmFd;
    void* m_mappedAddress;

public:
    SharedMemorySegment(std::string_view name, size_t size) 
        : m_segmentName(name), m_size(size), m_shmFd(-1), m_mappedAddress(nullptr) {}

    ~SharedMemorySegment() {
        if (m_mappedAddress) {
            munmap(m_mappedAddress, m_size);
        }
        if (m_shmFd >= 0) {
            close(m_shmFd);
        }
    }

    // Inicializa el segmento creando el objeto de memoria compartida en /dev/shm
    bool createSegment() {
        // O_CREAT | O_RDWR garantiza la creacion y permisos de lectura/escritura
        m_shmFd = shm_open(m_segmentName.c_str(), O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
        if (m_shmFd < 0) {
            perror("[SHM] Error al ejecutar shm_open");
            return false;
        }

        // Definir el tamaño físico asignado al segmento
        if (ftruncate(m_shmFd, m_size) < 0) {
            perror("[SHM] Error al truncar el segmento");
            return false;
        }

        // Proyectar el segmento al espacio de direcciones virtuales del proceso actual
        m_mappedAddress = mmap(nullptr, m_size, PROT_READ | PROT_WRITE, MAP_SHARED, m_shmFd, 0);
        if (m_mappedAddress == MAP_FAILED) {
            perror("[SHM] Error al mapear memoria");
            m_mappedRegionClear();
            return false;
        }

        return true;
    }

    void* getAccessPointer() const {
        return m_mappedAddress;
    }

    // Remueve el identificador del segmento global del sistema operativo
    void unlinkSegment() {
        shm_unlink(m_segmentName.c_str());
    }

private:
    void m_mappedRegionClear() {
        if (m_shmFd >= 0) close(m_shmFd);
        m_shmFd = -1;
        m_mappedAddress = nullptr;
    }
};

int main() {
    std::string_view shmName = "/net_shared_buffer";
    size_t segmentSize = sizeof(SharedNetworkState);

    SharedMemorySegment shmHandle(shmName, segmentSize);

    if (shmHandle.createSegment()) {
        // Obtener el puntero y castearlo a nuestra estructura compartida
        SharedNetworkState* state = static_cast<SharedNetworkState*>(shmHandle.getAccessPointer());
        
        // Escribir datos de control de infraestructura
        state->activeNetworkCount = 2; 
        std::strncpy(state->primaryInterface, "wlan0", sizeof(state->primaryInterface));
        state->isInterfaceLocked = false;

        std::cout << "[SHM] Segmento configurado correctamente. Interfaz activa: " 
                  << state->primaryInterface << "\n";
        
        // Retirar el enlace cuando la ejecucion de la sesion termine de forma definitiva
        shmHandle.unlinkSegment();
    }

    return 0;
}
