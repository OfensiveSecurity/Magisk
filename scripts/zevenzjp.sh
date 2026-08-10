#!/bin/bash

# --- CONFIGURACIÓN DE VARIABLES ---
ACCION="comprimir"               # Opciones: "comprimir", "extraer", "listar", "probar"
ARCHIVO_7Z="mi_archivo.7z"       # Nombre del archivo comprimido resultante o destino
RUTA_ORIGEN="./mi_carpeta"       # Carpeta o archivo que quieres procesar
CARPETA_DESTINO="./extraido"    # Carpeta donde se extraerán los archivos
CONTRASENA="TuPassword123"       # Deja vacío "" si no quieres usar contraseña


# --- EJECUCIÓN DEL SCRIPT ---
case $ACCION in
  "comprimir")
    echo "Comprimiendo $RUTA_ORIGEN en $ARCHIVO_7Z..."
    # -mx9: Compresión ultra
    # -p: Asigna contraseña (si existe)
    # -mhe=on: Encripta también los nombres de los archivos dentro del 7z
    if [ -z "$CONTRASENA" ]; then
      7z a -mx9 "$ARCHIVO_7Z" "$RUTA_ORIGEN"
    else
      7z a -mx9 -p"$CONTRASENA" -mhe=on "$ARCHIVO_7Z" "$RUTA_ORIGEN"
    fi
    ;;

  "extraer")
    echo "Extrayendo $ARCHIVO_7Z en $CARPETA_DESTINO..."
    # x: Extrae manteniendo la estructura de carpetas completa
    # -o: Especifica el directorio de salida
    # -y: Responde "Sí" a todas las preguntas (como sobrescribir)
    if [ -z "$CONTRASENA" ]; then
      7z x "$ARCHIVO_7Z" -o"$CARPETA_DESTINO" -y
    else
      7z x "$ARCHIVO_7Z" -p"$CONTRASENA" -o"$CARPETA_DESTINO" -y
    fi
    ;;

  "listar")
    echo "Contenido del archivo $ARCHIVO_7Z:"
    # l: Lista el contenido sin extraer nada
    7z l "$ARCHIVO_7Z"
    ;;

  "probar")
    echo "Probando la integridad de $ARCHIVO_7Z..."
    # t: Verifica si el archivo está corrupto
    if [ -z "$CONTRASENA" ]; then
      7z t "$ARCHIVO_7Z"
    else
      7z t "$ARCHIVO_7Z" -p"$CONTRASENA"
    fi
    ;;

  *)
    echo "Acción no válida. Elige: comprimir, extraer, listar o probar."
    ;;
esac

echo "¡Proceso terminado!"
