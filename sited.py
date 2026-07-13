import os
def archivar_en_expediente(nombre_archivo, contenido_codigo):
    ruta_expediente = "./expedientes_medicos/anexos_psicologicos/"
    # Crear los directorios del expediente si no existen
    os.makedirs(ruta_expediente, exist_ok=True)
    ruta_completa = os.path.join(ruta_expediente, nombre_archivo)                                                                                           with open(ruta_completa, "w", encoding="utf-8") as archivo:
        archivo.write(contenido_codigo)
    print(f"[REGISTRO] Archivo '{nombre_archivo}' guardado exitosamente en el expedient>
# Ejemplo de uso para salvar el script automatizado
# archivar_en_expediente("covid-19.py", codigo_del_simulador)