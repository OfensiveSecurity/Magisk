# 🛡️ ARC4 Crypto Suite v1.0

Una herramienta profesional de cifrado de flujo basada en el kernel ARC4, diseñada para ser modular, segura y automatizada.

## 🧩 Características Principal
Este sistema funciona como un rompecabezas de seguridad donde cada pieza cumple un rol vital:
* **Kernel ARC4:** Cifrado de flujo simétrico de alta velocidad.
* **Key Hardening:** Hash interno para robustecer claves débiles.
* **Compresión RLE:** Optimización de espacio y difusión de datos antes del cifrado.
* **Integridad:** Verificación de firma y checksum para evitar descifrados erróneos.
* **Shredder:** Borrado seguro de archivos originales (sobrescritura física).
* **Batch Processing:** Automatización para procesar carpetas completas.
* **Logger & Notifier:** Registro de actividad y alertas visuales/sonoras.

---

## 🚀 Instalación y Compilación

### Requisitos
* Compilador de C++ (GCC 7+ o Clang) con soporte para **C++17**.
* (Opcional en Linux) `libnotify-bin` para notificaciones visuales.

### Compilación rápida
Utiliza el `Makefile` incluido para construir el proyecto:
```bash
make
