#include <iostream>
#include <string>
#include <iomanip>
#include <curl/curl.h>

static size_t escribir(void* datos, size_t tam, size_t n, std::string* out) {
    out->append((char*)datos, tam * n);
    return tam * n;
}

std::string extraerTexto(const std::string& json) {
    size_t pos = json.find("\"text\":");
    if (pos == std::string::npos) return json;
    pos += 8;
    if (json[pos] == '"') pos++;
    size_t fin = json.find("\"", pos);
    std::string txt = json.substr(pos, fin - pos);
    std::string res;
    for (size_t i = 0; i < txt.size(); i++) {
        if (txt[i] == '\\' && i+1 < txt.size()) {
            if      (txt[i+1] == 'n') { res += '\n'; i++; }
            else if (txt[i+1] == 't') { res += '\t'; i++; }
            else if (txt[i+1] == '"') { res += '"';  i++; }
            else res += txt[i];
        } else res += txt[i];
    }
    return res;
}

std::string gemini(const std::string& clave, const std::string& prompt) {
    CURL* curl = curl_easy_init();
    if (!curl) return "[Error curl init]";

    std::string respuesta;
    std::string url = "https://generativelanguage.googleapis.com/v1beta/models/"                      "gemini-2.0-flash:generateContent?key=" + clave;
    std::string body = "{\"contents\":[{\"parts\":[{\"text\":\"" + prompt + "\"}]}]}";

    struct curl_slist* h = nullptr;
    h = curl_slist_append(h, "Content-Type: application/json");

    curl_easy_setopt(curl, CURLOPT_URL,           url.c_str());
    curl_easy_setopt(curl, CURLOPT_POST,          1L);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS,    body.c_str());
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER,    h);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, escribir);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA,     &respuesta);
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER,1L);
    curl_easy_setopt(curl, CURLOPT_TIMEOUT,       30L);

    CURLcode rc = curl_easy_perform(curl);
    curl_slist_free_all(h);
    curl_easy_cleanup(curl);

    if (rc != CURLE_OK)
        return std::string("[curl error: ") + curl_easy_strerror(rc) + "]";
    return extraerTexto(respuesta);
}

int main() {
    const double P  = 9600000000.0;   // 9.6 GW
    const double kV = 765.0;
    const double V  = kV * 1000.0;
    const double I  = P / V;
    const double R  = V / I;

    std::cout << std::fixed << std::setprecision(4);
    std::cout << "===========================================\n";
    std::cout << "  SISTEMA 9,600,000,000.0000 W  (9.6 GW) \n";
    std::cout << "===========================================\n";
    std::cout << "Potencia:    " << P  << " W\n";
    std::cout << "Voltaje:     " << V  << " V  (" << kV << " kV)\n";
    std::cout << "Corriente:   " << I  << " A\n";
    std::cout << "Resistencia: " << R  << " ohms\n";
    std::cout << "Vataje seg.: " << P*2 << " W (x2)\n";
    std::cout << "===========================================\n\n";

    std::cout << "Gemini API Key: ";
    std::string clave;
    std::cin >> clave;

    std::string prompt =
        "Ingeniero electrico. Sistema ultra alta potencia: "
        "9.6GW, 765kV, " + std::to_string(I) + "A. "
        "Explica: 1)Aplicaciones reales de 9.6GW "
        "2)Componentes criticos "
        "3)Riesgos principales "
        "4)Materiales para resistencias a 765kV. "
        "Responde en espanol, conciso.";

    std::cout << "\nConsultando Gemini...\n\n";
    std::cout << "--- Analisis ---\n" << gemini(clave, prompt) << "\n";
    return 0;
}