![](docs/images/logo.png)

[![Downloads](https://img.shields.io/badge/dynamic/json?color=green&label=Downloads&query=totalString&url=https%3A%2F%2Fraw.githubusercontent.com%2Ftopjohnwu%2Fmagisk-files%2Fcount%2Fcount.json&cacheSeconds=1800)](https://raw.githubusercontent.com/topjohnwu/magisk-files/count/count.json)

#### This is not an officially supported Google product

## Introduction

Magisk is a suite of open source software for customizing Android, supporting devices higher than Android 6.0.<br>
Some highlight features:

- **MagiskSU**: Provide root access for applications
- **Magisk Modules**: Modify read-only partitions by installing modules
- **MagiskBoot**: The most complete tool for unpacking and repacking Android boot images
- **Zygisk**: Run code in every Android applications' processes

## Downloads

[Github](https://github.com/topjohnwu/Magisk/releases) is the only source where you can get official Magisk information and downloads.

## Useful Links

- [Installation Instruction](https://topjohnwu.github.io/Magisk/install.html)
- [Building and Development](https://topjohnwu.github.io/Magisk/build.html)
- [Magisk Documentation](https://topjohnwu.github.io/Magisk/)
- [Zygisk module sample](https://github.com/topjohnwu/zygisk-module-sample)

## Bug Reports

**Only bug reports from Debug builds will be accepted.**

For installation issues, upload both boot image and install logs.<br>
For Magisk issues, upload boot logcat or dmesg.<br>
For Magisk app crashes, record and upload the logcat when the crash occurs.

## Translation Contributions

Default string resources for the Magisk app and its stub APK are located here:

- `app/core/src/main/res/values/strings.xml`
- `app/stub/src/main/res/values/strings.xml`

Translate each and place them in the respective locations (`[module]/src/main/res/values-[lang]/strings.xml`).

## License

    Magisk, including all git submodules are free software:
    you can redistribute it and/or modify it under the terms of the
    GNU General Public License as published by the Free Software Foundation,
    either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
# NEXUS Tactical Orchestrator v5.0 (OSCP Edition)

## Descripción
Framework de post-explotación y transferencia de archivos automatizada desarrollado en C/C++ para entornos móviles (Termux/Android). Diseñado para optimizar la fase de infiltración en laboratorios de la PEN-200.

## Características Técnicas
- **Dynamic IP Sensing:** Detección automática de interfaces con prioridad en `tun0` (VPN) sobre `wlan0`.
- **Socket Watchdog:** Monitoreo en tiempo real de logs de red con notificaciones sonoras y hápticas (Vibración/TTS).
- **Multi-Environment Support:** Administrador de PATH para compilación cruzada en C++, Java y ejecución de scripts PHP.
- **Auto-Cleanup:** Comandos integrados para revertir cambios en el objetivo y eliminar rastros de binarios.

## Estructura del Proyecto
- `nexus_core.c`: Orquestador principal y gestión de red.
- `nexus_bridge.cpp`: Puente de bajo nivel para estabilidad de sockets.
- `NexusParser.java`: Procesador de hashes NTLM.
- `nexus_deploy.sh`: Script de despliegue y corrección de dependencias.
# 🛡️ Magisk Custom Build - Android CI/CD & Anti-Spam Shield

Este repositorio contiene una versión personalizada de **Magisk**, optimizada para compilarse en entornos limpios de **GitHub Actions** y con herramientas integradas de seguridad nativa en **C++**.

## 🚀 Características Principales
- **Build Blindado:** Limpieza automática de repositorios conflictivos (Parrot/Kali) en el CI para evitar errores de enlace dinámico (`glibc`).
- **Escudo Anti-Spam:** Binario nativo en C++ que interactúa con el firewall del kernel para bloquear números de telemarketing.
- **Distribución Local:** Servidor web integrado en Termux con generación de códigos QR para descargas rápidas.
- **Reportes Automáticos:** Notificaciones de éxito de compilación y reportes semanales de bloqueo vía Telegram.

## 🛠️ Estructura del Proyecto
- `.github/workflows/android.yml`: Pipeline de compilación y limpieza de `apt`.
- `antispam.cpp`: Código fuente del escudo de red de bajo nivel.
- `spam_admin.py`: Panel de control web para gestión de lista negra.
- `get_magisk.py`: Script de sincronización entre GitHub Artifacts y Termux.

## 📦 Instalación en Termux
Para sincronizar tu compilación localmente, usa el alias maestro:
```bash
actualizar_magisk
# 🧹 Gestor de Limpieza Kali (v1.0)

Sistema profesional de automatización para la limpieza de instaladores (`.apk`, `.deb`) en entornos Android/Kali, con gestión de usuarios y estadísticas.

## ✨ Características
* **Limpieza Automática**: Borra archivos pesados de `/sdcard/Download`.
* **Seguridad**: Autenticación multiusuario con hashes SHA-1.
* **Base de Datos**: Almacenamiento persistente en SQLite.
* **Reportes**: Generación de logs detallados y gráficas ASCII.
* **Automatización**: Configurado con `cron` para ejecuciones programadas.

## 🚀 Instalación Rápida
Clona este repositorio o copia los archivos y ejecuta el instalador:

```bash
chmod +x instalar.sh
./instalar.sh

