#include <stdio.h>
#include <curl/curl.h>

int main(void) {
    CURL *curl;
    CURLcode res;

    curl = curl_easy_init();
    if(curl) {
        // Establecer la URL del módem
        curl_easy_setopt(curl, CURLOPT_URL, "http://192.168.100.1/login.cgi");
        
        // Autenticación root:admin
        curl_easy_setopt(curl, CURLOPT_USERPWD, "root:admin");

        // Realizar la petición
        res = curl_easy_perform(curl);

        if(res != CURLE_OK)
            fprintf(stderr, "Error: %s\n", curl_easy_strerror(res));

        curl_easy_cleanup(curl);
    }
    return 0;
}
