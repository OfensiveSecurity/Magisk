#include <iostream>
#include <vector>
#include <jalapeno_runtime.h> // API hipotética del SDK de OpenAI/Broadcom

// Configuración de dimensiones para las matrices de inferencia
const int MATRIX_SIZE = 4096; 

int main() {
    // 1. Inicializar el entorno de ejecución del chip Jalapeño
    jpResult status = jpInit(0);
    if (status != JP_SUCCESS) {
        std::cerr << "Error: No se pudo inicializar el chip Jalapeño." << std::endl;
        return -1;
    }

    // 2. Crear flujos de ejecución (Streams) para procesamiento asíncrono
    jpStream_t stream;
    jpStreamCreate(&stream);

    // 3. Reservar memoria en el Host (CPU) y preparar datos de prueba
    size_t bytes = MATRIX_SIZE * MATRIX_SIZE * sizeof(float);
    std::vector<float> h_A(MATRIX_SIZE * MATRIX_SIZE, 1.0f);
    std::vector<float> h_B(MATRIX_SIZE * MATRIX_SIZE, 2.0f);
    std::vector<float> h_C(MATRIX_SIZE * MATRIX_SIZE, 0.0f);

    // 4. Reservar memoria directamente en la SRAM/HBM del chip Jalapeño
    float *d_A, *d_B, *d_C;
    jpMalloc((void**)&d_A, bytes);
    jpMalloc((void**)&d_B, bytes);
    jpMalloc((void**)&d_C, bytes);

    // 5. Transferir los pesos del modelo y datos de entrada al ASIC
    jpMemcpyHtoDAsync(d_A, h_A.data(), bytes, stream);
    jpMemcpyHtoDAsync(d_B, h_B.data(), bytes, stream);

    // 6. Ejecutar la operación optimizada en los núcleos de inferencia
    // Jalapeño utiliza unidades de matriz dedicadas de ultra baja latencia
    float alpha = 1.0f;
    float beta = 0.0f;
    jpTensorMatMul(stream, d_A, d_B, d_C, MATRIX_SIZE, MATRIX_SIZE, MATRIX_SIZE, &alpha, &beta);

    // 7. Descargar los resultados de la inferencia de vuelta a la CPU
    jpMemcpyDtoHAsync(h_C.data(), d_C, bytes, stream);

    // Sincronizar el flujo para asegurar que el chip terminó la tarea
    jpStreamSynchronize(stream);

    // 8. Validar el resultado de la operación
    std::cout << "Inferencia completada exitosamente en Jalapeño." << std::endl;
    std::cout << "Resultado en la celda: " << h_C[0] << " (Esperado: " << MATRIX_SIZE * 2.0f << ")" << std::endl;

    // 9. Limpieza de recursos
    jpFree(d_A);
    jpFree(d_B);
    jpFree(d_C);
    jpStreamDestroy(stream);
    jpShutdown();

    return 0;
}
