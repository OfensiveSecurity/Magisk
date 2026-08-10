#include <iostream>
#include <vector>
#include <string>

struct SecurityEvent {
    std::string source;
    std::string description;
    int severity;
};

class BreachFusion {
public:
    void addEvent(const SecurityEvent& event) {
        events.push_back(event);
    }

    void analyze() {
        for (const auto& e : events) {
            if (e.severity >= 8) {
                std::cout << "[ALERTA] "
                          << e.description
                          << std::endl;
            }
        }
    }

private:
    std::vector<SecurityEvent> events;
};

int main() {
    BreachFusion fusion;

    fusion.addEvent({
        "WiFi",
        "Intentos repetidos de autenticación fallida",
        9
    });

    fusion.analyze();
}













                                      [ Read 41 lines ]
^G Help        ^O Write Out   ^F Where Is    ^K Cut         ^T Execute     ^C Location
^X Exit        ^R Read File   ^\ Replace     ^U Paste       ^J Justify     ^/ Go To Line
