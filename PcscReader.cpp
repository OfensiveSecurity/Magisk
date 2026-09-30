#include "PcscReader.h"

#include <iomanip>
#include <sstream>
#include <vector>
#include <cwchar>

namespace
{
    std::string bytesToHex(
        const BYTE* data,
        DWORD size
    )
    {
        std::ostringstream out;

        for (DWORD i = 0; i < size; ++i)
        {
            if (i != 0)
                out << ' ';

            out
                << std::uppercase
                << std::hex
                << std::setw(2)
                << std::setfill('0')
                << static_cast<unsigned int>(data[i]);
        }

        return out.str();
    }
}

PcscReader::PcscReader()
{
}

PcscReader::~PcscReader()
{
    disconnect();

    if (context_ != 0)
    {
        SCardReleaseContext(context_);
        context_ = 0;
    }
}

bool PcscReader::initialize()
{
    if (context_ != 0)
        return true;

    LONG result = SCardEstablishContext(
        SCARD_SCOPE_SYSTEM,
        nullptr,
        nullptr,
        &context_
    );

    return result == SCARD_S_SUCCESS;
}

std::vector<ReaderInfo> PcscReader::listReaders()
{
    std::vector<ReaderInfo> result;

    if (context_ == 0)
        return result;

    DWORD size = SCARD_AUTOALLOCATE;
    LPWSTR multiString = nullptr;

    LONG status = SCardListReadersW(
        context_,
        nullptr,
        reinterpret_cast<LPWSTR>(&multiString),
        &size
    );

    if (status != SCARD_S_SUCCESS)
        return result;

    LPWSTR current = multiString;

    while (*current != L'\0')
    {
        ReaderInfo info;
        info.name = current;

        getReaderStatus(info.name, info);

        result.push_back(info);

        current += std::wcslen(current) + 1;
    }

    SCardFreeMemory(
        context_,
        multiString
    );

    return result;
}

bool PcscReader::getReaderStatus(
    const std::wstring& readerName,
    ReaderInfo& info
)
{
    if (context_ == 0)
        return false;

    SCARD_READERSTATEW state{};

    state.szReader = readerName.c_str();
    state.dwCurrentState = SCARD_STATE_UNAWARE;

    LONG status = SCardGetStatusChangeW(
        context_,
        0,
        &state,
        1
    );

    if (status != SCARD_S_SUCCESS)
        return false;

    info.name = readerName;
    info.state = state.dwEventState;
    info.protocol = 0;
    info.atrHex.clear();
    info.atrLength = state.cbAtr;

    if (state.cbAtr > 0)
    {
        info.atrHex =
            bytesToHex(state.rgbAtr, state.cbAtr);
    }

    if (state.dwEventState & SCARD_STATE_INUSE)
        info.state |= SCARD_STATE_INUSE;

    return true;
}

bool PcscReader::connect(
    const std::wstring& readerName
)
{
    disconnect();

    if (context_ == 0)
        return false;

    SCARDHANDLE card = 0;
    DWORD activeProtocol = 0;

    LONG status = SCardConnectW(
        context_,
        readerName.c_str(),
        SCARD_SHARE_SHARED,
        SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1,
        &card,
        &activeProtocol
    );

    if (status != SCARD_S_SUCCESS)
        return false;

    card_ = card;
    protocol_ = activeProtocol;
    readerName_ = readerName;

    ReaderInfo info;

    if (!getCardStatus(info))
    {
        disconnect();
        return false;
    }

    atrHex_ = info.atrHex;

    return true;
}

void PcscReader::disconnect()
{
    if (card_ != 0)
    {
        SCardDisconnect(
            card_,
            SCARD_LEAVE_CARD
        );

        card_ = 0;
    }

    protocol_ = 0;
    readerName_.clear();
    atrHex_.clear();
}

bool PcscReader::getCardStatus(
    ReaderInfo& info
)
{
    if (card_ == 0)
        return false;

    DWORD state = 0;
    DWORD protocol = 0;

    WCHAR reader[256]{};
    DWORD readerLength = 256;

    BYTE atr[64]{};
    DWORD atrLength = sizeof(atr);

    LONG status = SCardStatusW(
        card_,
        reader,
        &readerLength,
        &state,
        &protocol,
        atr,
        &atrLength
    );

    if (status != SCARD_S_SUCCESS)
        return false;

    info.name.assign(reader, readerLength);
    info.state = state;
    info.protocol = protocol;
    info.atrLength = atrLength;

    if (atrLength > 0)
    {
        info.atrHex =
            bytesToHex(atr, atrLength);
    }

    return true;
}

bool PcscReader::getReaderAttributes(
    DWORD& vendorName,
    DWORD& vendorIfdType,
    DWORD& vendorIfdVersion,
    DWORD& maxInput,
    DWORD& maxOutput
)
{
    vendorName = 0;
    vendorIfdType = 0;
    vendorIfdVersion = 0;
    maxInput = 0;
    maxOutput = 0;

    if (card_ == 0)
        return false;

    DWORD size = sizeof(DWORD);

    LONG status = SCardGetAttrib(
        card_,
        SCARD_ATTR_VENDOR_NAME,
        reinterpret_cast<LPBYTE>(&vendorName),
        &size
    );

    // SCARD_ATTR_VENDOR_NAME normalmente es texto,
    // por lo que no tratamos este DWORD como un nombre.
    // Consultamos los atributos numéricos de forma independiente.

    size = sizeof(DWORD);

    if (SCardGetAttrib(
        card_,
        SCARD_ATTR_VENDOR_IFD_TYPE,
        reinterpret_cast<LPBYTE>(&vendorIfdType),
        &size
    ) != SCARD_S_SUCCESS)
    {
        vendorIfdType = 0;
    }

    size = sizeof(DWORD);

    if (SCardGetAttrib(
        card_,
        SCARD_ATTR_VENDOR_IFD_VERSION,
        reinterpret_cast<LPBYTE>(&vendorIfdVersion),
        &size
    ) != SCARD_S_SUCCESS)
    {
        vendorIfdVersion = 0;
    }

    size = sizeof(DWORD);

    if (SCardGetAttrib(
        card_,
        SCARD_ATTR_MAXINPUT,
        reinterpret_cast<LPBYTE>(&maxInput),
        &size
    ) != SCARD_S_SUCCESS)
    {
        maxInput = 0;
    }

    size = sizeof(DWORD);

    if (SCardGetAttrib(
        card_,
        SCARD_ATTR_MAXOUTPUT,
        reinterpret_cast<LPBYTE>(&maxOutput),
        &size
    ) != SCARD_S_SUCCESS)
    {
        maxOutput = 0;
    }

    return status == SCARD_S_SUCCESS;
}

std::wstring PcscReader::readerName() const
{
    return readerName_;
}

std::string PcscReader::atr() const
{
    return atrHex_;
}

DWORD PcscReader::protocol() const
{
    return protocol_;
}