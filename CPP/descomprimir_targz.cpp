#include <iostream>
#include <fstream>
#include <vector>
#include <cstring>
#include <sys/stat.h>
#include <zlib.h>

struct TarHeader {                                                                                                                                                                   char name[100];
    char mode[8];
    char uid[8];
    char gid[8];
    char size[12];
    char mtime[12];
    char chksum[8];
    char typeflag;
    char linkname[100];
    char magic[6];
    char version[2];
    char uname[32];
    char gname[32];
    char devmajor[8];
    char devminor[8];
    char prefix[155];
    char padding[12];
};

long octalToDecimal(const char* str, size_t size) {
    long result = 0;
    for (size_t i = 0; i < size && str[i] != '\0'; i++) {
        if (str[i] < '0' || str[i] > '7') continue;
        result = result * 8 + (str[i] - '0');
    }
    return result;
}

void createDirectories(const std::string& path) {
    std::string current;
    for (size_t i = 0; i < path.size(); i++) {
        current += path[i];
        if (path[i] == '/') {
            mkdir(current.c_str(), 0755);
        }
    }
}

std::vector<unsigned char> decompressGzip(const std::string& filename) {
    gzFile file = gzopen(filename.c_str(), "rb");
    if (!file) {
        throw std::runtime_error("No se pudo abrir el archivo: " + filename);
    }

    std::vector<unsigned char> buffer;
    const size_t chunkSize = 65536;
    unsigned char chunk[chunkSize];
    int bytesRead;

    while ((bytesRead = gzread(file, chunk, chunkSize)) > 0) {
        buffer.insert(buffer.end(), chunk, chunk + bytesRead);
    }

    gzclose(file);
    return buffer;
}

void extractTar(const std::vector<unsigned char>& tarData, const std::string& outputDir) {
    size_t offset = 0;
    int filesExtracted = 0;

    mkdir(outputDir.c_str(), 0755);

    while (offset + 512 <= tarData.size()) {
        TarHeader header;