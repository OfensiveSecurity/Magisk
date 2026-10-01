#include <iostream>
#include <winrt/Windows.Foundation.h>
#include <winrt/Microsoft.WSL.Containers.h> // Namespace conceptual del paquete

using namespace winrt;
using namespace Microsoft::WSL::Containers;

int main()
{
    // Inicializar el runtime de WinRT
    init_apartment();

    try {
        std::cout << "Inicializando gestor de contenedores WSL...\n";

        // Crear una instancia del servicio de contenedores
        WslContainerManager manager;

        // Configurar opciones de ejecución (ej. imagen de Ubuntu)
        WslContainerConfiguration config;
        config.ImageName(L"ubuntu:latest");
        config.Command(L"/bin/bash -c 'echo Hola desde un contenedor Linux nativo en Windows!'");

        // Ejecutar el contenedor de forma asíncrona o sincrónica
        auto operation = manager.RunContainerAsync(config);
        auto result = operation.get();

        std::cout << "Contenedor ejecutado con éxito. Código de salida: " << result.ExitCode() << "\n";
    }
    catch (const hresult_error& ex) {
        std::wcerr << L"Error al ejecutar el contenedor: " << ex.message() << std::endl;
    }

    return 0;
}