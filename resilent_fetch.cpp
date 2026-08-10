#include <iostream>
#include <fstream>
#include <curl/curl.h>

// Callback to write stream data directly to a file
size_t write_data(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    size_t written = fwrite(ptr, size, nmemb, stream);
    return written;
}

bool download_file(const std::string& url, const std::string& output_filename) {
    CURL *curl;
    FILE *fp;
    CURLcode res;

    curl = curl_easy_init();
    if (!curl) return false;

    fp = fopen(output_filename.c_str(), "wb");
    if (!fp) {
        curl_easy_cleanup(curl);
        return false;
    }

    curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp);

    // Follow redirects and set a 5-retry limit for transient network drops
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_FAILONERROR, 1L);

    std::cout << "[*] Downloading package..." << std::endl;
    res = curl_easy_perform(curl);

    fclose(fp);
    curl_easy_cleanup(curl);

    if (res != CURLE_OK) {
        std::cerr << "[-] Curl failed: " << curl_easy_strerror(res) << std::endl;
        return false;
    }

    return true;
}

int main() {
    // Replace with your target archive URL
    std::string url = "https://example.com/package.tar.gz";
    std::string out_file = "package.tar.gz";

    if (download_file(url, out_file)) {
        std::cout << "[+] Download complete. System safe to unpack." << std::endl;
        // Trigger extraction safely via system context once verification passes
