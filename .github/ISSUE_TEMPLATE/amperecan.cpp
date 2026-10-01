#include <Arduino.h>
#include <OneWire.h>
#include <DallasTemperature.h>

// -------------------------
// Pines
// -------------------------
constexpr uint8_t PIN_DS18B20 = 4;
constexpr uint8_t PIN_CURRENT  = 34;
constexpr uint8_t PIN_SSR      = 23;

// -------------------------
// Límites
// -------------------------
constexpr float MAX_CURRENT_A = 10.0f;
constexpr float CURRENT_TRIP_A = 11.0f;

constexpr float MAX_TEMP_C = 60.0f;
constexpr float TEMP_TRIP_C = 65.0f;

constexpr float TEMP_HYSTERESIS_C = 2.0f;

// -------------------------
// Sensor de corriente
// -------------------------
// EJEMPLO únicamente.
// Sustituir por los valores reales del sensor.
constexpr float CURRENT_SENSOR_OFFSET = 2048.0f;
constexpr float CURRENT_SENSOR_SCALE  = 0.010f;

// -------------------------
// Control
// -------------------------
bool heaterEnabled = false;
bool fault = false;

OneWire oneWire(PIN_DS18B20);
DallasTemperature sensors(&oneWire);

// -------------------------
// SSR
// -------------------------
void heaterOff()
{
    digitalWrite(PIN_SSR, LOW);
    heaterEnabled = false;
}

void heaterOn()
{
    if (!fault) {
        digitalWrite(PIN_SSR, HIGH);
        heaterEnabled = true;
    }
}

// -------------------------
// Lectura corriente
// -------------------------
float readCurrentA()
{
    constexpr int samples = 32;

    uint32_t sum = 0;

    for (int i = 0; i < samples; ++i) {
        sum += analogRead(PIN_CURRENT);
        delayMicroseconds(200);
    }

    float adc = static_cast<float>(sum) / samples;

    float current =
        (adc - CURRENT_SENSOR_OFFSET) *
        CURRENT_SENSOR_SCALE;

    if (current < 0.0f)
        current = -current;

    return current;
}

// -------------------------
// Temperatura
// -------------------------
float readTemperatureC()
{
    sensors.requestTemperatures();

    float t = sensors.getTempCByIndex(0);

    return t;
}

// -------------------------
// Falla segura
// -------------------------
void triggerFault(const char *reason)
{
    heaterOff();
    fault = true;

    Serial.print("FAULT: ");
    Serial.println(reason);
}

// -------------------------
// Setup
// -------------------------
void setup()
{
    Serial.begin(115200);

    pinMode(PIN_SSR, OUTPUT);

    // Estado seguro al arrancar
    heaterOff();

    analogReadResolution(12);

    sensors.begin();

    Serial.println();
    Serial.println("=== ESP32 WATER HEATER CONTROLLER ===");
    Serial.println("SSR inicializado en OFF");
}

// -------------------------
// Loop
// -------------------------
void loop()
{
    if (fault) {
        heaterOff();

        Serial.println("FAULT LATCHED -> SSR OFF");

        delay(1000);
        return;
    }

    float temperature = readTemperatureC();
    float current = readCurrentA();

    Serial.print("Temp: ");
    Serial.print(temperature);
    Serial.print(" C | Current: ");
    Serial.print(current);
    Serial.println(" A");

    // --------------------------------
    // Sensor de temperatura inválido
    // --------------------------------
    if (temperature == DEVICE_DISCONNECTED_C ||
        temperature < -40.0f ||
        temperature > 125.0f) {

        triggerFault("DS18B20 INVALID");
        return;
    }

    // --------------------------------
    // Sobretemperatura
    // --------------------------------
    if (temperature >= TEMP_TRIP_C) {

        triggerFault("OVER TEMPERATURE");
        return;
    }

    // --------------------------------
    // Sobrecorriente
    // --------------------------------
    if (current >= CURRENT_TRIP_A) {

        triggerFault("OVER CURRENT");
        return;
    }

    // --------------------------------
    // Control de temperatura
    // --------------------------------
    if (temperature >= MAX_TEMP_C) {
        heaterOff();
    }
    else if (temperature <=
             (MAX_TEMP_C - TEMP_HYSTERESIS_C)) {

        // Sólo permite encender si la corriente
        // medida está dentro del límite normal.
        if (current <= MAX_CURRENT_A) {
            heaterOn();
        }
        else {
            heaterOff();
        }
    }

    delay(1000);
}