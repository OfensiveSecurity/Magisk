#!/bin/bash
compilar_satelite_dll "FormularioPrincipal.es-MX.resources" "es-MX" "FormularioPrincipal.resources.d>
# Función para compilar un archivo de recursos en una DLL satélite usando Mono al
compilar_satelite_dll() {
    local archivo_recurso="$1"  # Ej: Mensajes.es.resources
    local cultura="$2"          # Ej: es (o es-MX, en-US, etc.)
    local dll_salida="$3"       # Ej: MiApp.resources.dll
    # Verificación rápida de que el archivo de recursos existe
    if [ ! -f "$archivo_recurso" ]; then
        echo "❌ Error: El archivo de recursos '$archivo_recurso' no existe."
        return 1
    fi
    echo "⚙️  Compilando ensamblado satélite para la cultura '$cultura'..."
    # Llamada a al (Assembly Linker de Mono)
    al \
      /target:lib \
      /culture:"$cultura" \
      /embed:"$archivo_recurso" \
      /out:"$dll_salida" \
      /nologo
    # Comprobar si al.exe terminó con éxito                                                              if [ $? -eq 0 ]; then
        echo "✅ ¡Éxito! Creado: $dll_salida"
    else
        echo "❌ Error: Falló la compilación con al.exe"
        return 1
    fi
}
# ==========================================
# EJEMPLO DE CÓMO LLAMAR A LA FUNCIÓN:
# ==========================================
# compilar_satelite_dll "MisMensajes.es.resources" "es" "MisMensajes.resources.dll"