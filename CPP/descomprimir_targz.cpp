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
        memcpy(&header, tarData.data() + offset, 512);
        offset += 512;

        bool isZero = true;
        const unsigned char* raw = reinterpret_cast<const unsigned char*>(&header);
        for (int i = 0; i < 512; i++) {
            if (raw[i] != 0) { isZero = false; break; }
        }
        if (isZero) break;

        std::string name(header.name);
        if (header.prefix[0] != '\0') {
            std::string prefix(header.prefix);
            name = prefix + "/" + name;
        }

        long size = octalToDecimal(header.size, 12);
        char typeflag = header.typeflag;
        std::string fullPath = outputDir + "/" + name;

        if (typeflag == '5') {
            createDirectories(fullPath + "/");
        } else if (typeflag == '0' || typeflag == '\0') {
            size_t lastSlash = fullPath.find_last_of('/');
            if (lastSlash != std::string::npos) {
                createDirectories(fullPath.substr(0, lastSlash + 1));
            }

            std::ofstream outFile(fullPath, std::ios::binary);
            if (outFile && size > 0) {
                outFile.write(reinterpret_cast<const char*>(tarData.data() + offset), size);
            }
            outFile.close();

            long mode = octalToDecimal(header.mode, 8);
            chmod(fullPath.c_str(), mode);

            filesExtracted++;
            if (filesExtracted % 50 == 0) {
                std::cout << "Extraidos: " << filesExtracted << " archivos...\n";
            }
        } else if (typeflag == '2') {
            std::cout << "Symlink omitido: " << name << " -> " << header.linkname << "\n";
        }
                                                                                                                                                                                         size_t blocks = (size + 511) / 512;
        offset += blocks * 512;
    }

    std::cout << "\nExtraccion completa. " << filesExtracted
               << " archivos extraidos en: " << outputDir << "\n";
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Uso: " << argv[0] << " <archivo.tar.gz> [directorio_salida]\n";
        std::cerr << "Ejemplo: " << argv[0] << " powershell-7.6.3-linux-arm64.tar.gz powershell\n";
        return 1;
    }

    std::string inputFile = argv[1];
    std::string outputDir = (argc >= 3) ? argv[2] : "salida";

    try {
        std::cout << "Descomprimiendo gzip: " << inputFile << "...\n";
        std::vector<unsigned char> tarData = decompressGzip(inputFile);
        std::cout << "Descompresion gzip completa (" << tarData.size() << " bytes). Extrayendo tar...\n";
        extractTar(tarData, outputDir);
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << "\n";
        return 1;
    }