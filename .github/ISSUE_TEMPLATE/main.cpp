#include "PcscReader.h"

#include <iostream>
#include <iomanip>
#include <string>
#include <limits>

static void clearScreen()
{
    system("cls");
}

static std::wstring protocolName(DWORD protocol)
{
    if (protocol == SCARD_PROTOCOL_T0)
        return L"T=0";

    if (protocol == SCARD_PROTOCOL_T1)
        return L"T=1";

    if (protocol == (SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1))
        return L"T=0/T=1";

    return L"Desconocido";
}

static std::wstring stateName(DWORD state)
{
    if (state & SCARD_STATE_EMPTY)
        return L"Sin tarjeta";

    if (state & SCARD_STATE_PRESENT)
        return L"Tarjeta presente";

    if (state & SCARD_STATE_UNAVAILABLE)
        return L"No disponible";

    if (state & SCARD_STATE_UNKNOWN)
        return L"Desconocido";

    return L"Estado no determinado";
}

static void showReaders(PcscReader& pcsc)
{
    auto readers = pcsc.listReaders();

    std::wcout
        << L"\n===== LECTORES PC/SC =====\n\n";

    if (readers.empty())
    {
        std::wcout
            << L"No hay lectores PC/SC disponibles.\n";
        return;
    }

    for (size_t i = 0; i < readers.size(); ++i)
    {
        std::wcout
            << L"[" << i << L"] "
            << readers[i].name
            << L"\n";

        std::wcout
            << L"    Estado   : "
            << stateName(readers[i].state)
            << L"\n";

        if (!readers[i].atrHex.empty())
        {
            std::wcout
                << L"    ATR      : ";

            std::cout
                << readers[i].atrHex
                << "\n";
        }

        std::wcout << L"\n";
    }
}

static int selectReader(PcscReader& pcsc)
{
    auto readers = pcsc.listReaders();

    if (readers.empty())
    {
        std::wcout
            << L"No se encontraron lectores.\n";

        return -1;
    }

    std::wcout
        << L"\nSeleccione lector:\n\n";

    for (size_t i = 0; i < readers.size(); ++i)
    {
        std::wcout
            << L"[" << i << L"] "
            << readers[i].name
            << L"\n";
    }

    std::wcout
        << L"\nÍndice: ";

    int index;
    std::cin >> index;

    if (!std::cin ||
        index < 0 ||
        index >= static_cast<int>(readers.size()))
    {
        std::cin.clear();
        std::cin.ignore(
            std::numeric_limits<std::streamsize>::max(),
            '\n'
        );

        return -1;
    }

    return index;
}

static void showCard(PcscReader& pcsc)
{
    ReaderInfo info;

    if (!pcsc.getCardStatus(info))
    {
        std::wcout
            << L"\nNo hay una tarjeta conectada.\n";
        return;
    }

    std::wcout
        << L"\n===== TARJETA =====\n\n";

    std::wcout
        << L"Lector   : "
        << info.name
        << L"\n";

    std::wcout
        << L"Estado   : "
        << stateName(info.state)
        << L"\n";

    std::wcout
        << L"Protocolo: "
        << protocolName(info.protocol)
        << L"\n";

    std::cout
        << "ATR      : "
        << info.atrHex
        << "\n";

    std::cout
        << "ATR bytes: "
        << info.atrLength
        << "\n";
}

static void showAttributes(PcscReader& pcsc)
{
    DWORD vendorName = 0;
    DWORD vendorType = 0;
    DWORD vendorVersion = 0;
    DWORD maxInput = 0;
    DWORD maxOutput = 0;

    if (!pcsc.getReaderAttributes(
        vendorName,
        vendorType,
        vendorVersion,
        maxInput,
        maxOutput))
    {
        std::wcout
            << L"\nNo se pudieron obtener los atributos "
               L"PC/SC.\n";

        return;
    }

    std::wcout
        << L"\n===== CAPACIDADES PC/SC =====\n\n";

    std::wcout
        << L"IFD type       : "
        << vendorType
        << L"\n";

    std::wcout
        << L"IFD version    : 0x"
        << std::hex
        << vendorVersion
        << std::dec
        << L"\n";

    std::wcout
        << L"Máx. entrada   : "
        << maxInput
        << L" bytes\n";

    std::wcout
        << L"Máx. salida    : "
        << maxOutput
        << L" bytes\n";

    std::wcout
        << L"\nPC/SC context  : activo\n";
}

int main()
{
    std::locale::global(
        std::locale("")
    );

    PcscReader pcsc;

    if (!pcsc.initialize())
    {
        std::cerr
            << "ERROR: no se pudo inicializar PC/SC.\n";

        return 1;
    }

    int selectedReader = -1;

    while (true)
    {
        clearScreen();

        std::wcout
            << L"========================================\n"
            << L"        NFC / PCSC INSPECTOR\n"
            << L"        Visual Studio 2022\n"
            << L"========================================\n\n";

        std::wcout
            << L"1. Listar lectores\n"
            << L"2. Seleccionar lector\n"
            << L"3. Mostrar tarjeta / ATR\n"
            << L"4. Mostrar protocolo T=0/T=1\n"
            << L"5. Mostrar capacidades PC/SC\n"
            << L"6. Refrescar estado\n"
            << L"7. Desconectar tarjeta\n"
            << L"0. Salir\n\n";

        std::wcout
            << L"Seleccione una opción: ";

        int option;
        std::cin >> option;

        if (!std::cin)
        {
            std::cin.clear();

            std::cin.ignore(
                std::numeric_limits<std::streamsize>::max(),
                '\n'
            );

            continue;
        }

        clearScreen();

        switch (option)
        {
        case 1:
            showReaders(pcsc);
            break;

        case 2:
        {
            int index = selectReader(pcsc);

            if (index >= 0)
            {
                auto readers = pcsc.listReaders();

                if (pcsc.connect(readers[index].name))
                {
                    selectedReader = index;

                    std::wcout
                        << L"\nConectado correctamente.\n";
                }
                else
                {
                    std::wcout
                        << L"\nNo se pudo conectar.\n";
                }
            }

            break;
        }

        case 3:
            showCard(pcsc);
            break;

        case 4:
        {
            ReaderInfo info;

            if (pcsc.getCardStatus(info))
            {
                std::wcout
                    << L"Protocolo activo: "
                    << protocolName(info.protocol)
                    << L"\n";
            }
            else
            {
                std::wcout
                    << L"No hay tarjeta conectada.\n";
            }

            break;
        }

        case 5:
            showAttributes(pcsc);
            break;

        case 6:
        {
            auto readers = pcsc.listReaders();

            std::wcout
                << L"Estado actualizado.\n\n";

            for (const auto& reader : readers)
            {
                std::wcout
                    << reader.name
                    << L" -> "
                    << stateName(reader.state)
                    << L"\n";
            }

            break;
        }

        case 7:
            pcsc.disconnect();
            selectedReader = -1;

            std::wcout
                << L"Tarjeta desconectada.\n";
            break;

        case 0:
            pcsc.disconnect();
            return 0;

        default:
            std::wcout
                << L"Opción no válida.\n";
            break;
        }

        std::wcout
            << L"\nPresiona ENTER para continuar...";

        std::cin.ignore(
            std::numeric_limits<std::streamsize>::max(),
            '\n'
        );

        std::cin.get();
    }
}