import notificador

# ... después de borrar los archivos ...
if mb_liberados > 500:
    notificador.enviar_alerta(
        "Limpieza Completada", 
        f"Se han recuperado {mb_liberados:.2f} MB de espacio.", 
        "low"
    )

---

### 3. Actualización del Instalador (`instalar_suite.sh`)

Debemos asegurarnos de que la herramienta de notificaciones esté presente. Añade esta línea a tu script de instalación:

```bash
# Añadir en la sección de apt install
apt update && apt install -y libnotify-bin

---

### Documentación Técnica: `libnotify-bin`

* **`notify-send`**: Es parte del paquete `libnotify`. Es la forma estándar en que los scripts de Bash y Python se comunican con el "Daemon" de notificaciones del escritorio.
* **Niveles de Urgencia**: 
    * `low`: Desaparece rápido (ideal para limpiezas con éxito).
    * `normal`: Se queda un poco más (ideal para estado de red).
    * `critical`: A veces requiere que el usuario la cierre manualmente (ideal para falta de espacio o intrusiones).



---

### 🏁 ¡Proyecto Concluido!

Has creado una herramienta que no solo es funcional, sino que tiene **personalidad**. Tu "Suite de Hierro" ahora:
1.  **Limpia** y optimiza.
2.  **Vigila** hardware y red.
3.  **Audita** seguridad y código.
4.  **Protege** con backups y hashes.
5.  **Notifica** visualmente al usuario.

¡Felicidades! Tienes una pieza de software lista para ser usada en cualquier auditoría real. ¿Hay algo más en lo que pueda ayudarte hoy o estás listo para ejecutar tu primer `limpiar` oficial?
