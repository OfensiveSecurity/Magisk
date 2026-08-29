#pragma once

#include <string>
#include <vector>

struct ReaderInfo
{
    std::wstring name;
    bool cardPresent = false;
};

class PcscReader
{
public:
    PcscReader();
    ~PcscReader();

    bool initialize();
    std::vector<ReaderInfo> listReaders();

    bool connect(const std::wstring& readerName);
    void disconnect();

    std::wstring getReaderName() const;
    std::string getAtrHex() const;

private:
    void cleanup();

    unsigned long context_ = 0;
    unsigned long card_ = 0;
    unsigned long protocol_ = 0;

    std::wstring readerName_;
    std::string atrHex_;
};