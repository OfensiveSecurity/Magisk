#include <cstdlib>
#include <iostream>
#include <string>

void startServer(const std::string& port) {
    std::cout << "Servidor de entrega activo en puerto: "
              << port << std::endl;

    std::string cmd = "python3 -m http.server " + port;
    std::system(cmd.c_str());
}

void setEnvVar(const std::string& name,
               const std::string& value) {

#ifdef _WIN32
    _putenv_s(name.c_str(), value.c_str());
#else
    setenv(name.c_str(), value.c_str(), 1);
#endif

    std::cout << name << "=" << value << std::endl;
}

int main(int argc, char* argv[]) {

    if (argc < 2) {
        std::cout
            << "Uso:\n"
            << "  butterfly server [puerto]\n"
            << "  butterfly setenv VAR VALOR\n";
        return 0;
    }

    std::string cmd = argv[1];

    if (cmd == "server") {
        std::string port = "80";

        if (argc >= 3)
            port = argv[2];

        startServer(port);
    }
    else if (cmd == "setenv" && argc >= 4) {
        setEnvVar(argv[2], argv[3]);
    }
    else {
        std::cerr << "Comando no reconocido\n";
        return 1;
    }

    return 0;
}

