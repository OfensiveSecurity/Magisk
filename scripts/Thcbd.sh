#!/bin/bash

# Función para limpiar la pantalla y mostrar el título
mostrar_titulo() {
    clear
    echo "=========================================================="
    echo "   BALANCE DE MASA EN BASH: BERILIO (Be) Y THC"
    echo "=========================================================="
    echo ""
}

mostrar_titulo

# 1. Entrada de datos de la Corriente 1
echo "--- CORRIENTE DE ENTRADA 1 ---"
read -p "Ingresa el flujo másico total de la Corriente 1 (kg o g): " F1
read -p "Ingresa el porcentaje (%) de Berilio en la Corriente 1: " porc_Be1
read -p "Ingresa el porcentaje (%) de THC en la Corriente 1: " porc_THC1
echo ""

# 2. Entrada de datos de la Corriente 2
echo "--- CORRIENTE DE ENTRADA 2 ---"
read -p "Ingresa el flujo másico total de la Corriente 2 (kg o g): " F2
read -p "Ingresa el porcentaje (%) de Berilio en la Corriente 2: " porc_Be2
read -p "Ingresa el porcentaje (%) de THC en la Corriente 2: " porc_THC2
echo ""

# Como Bash no maneja decimales de forma nativa, usamos 'bc' para los cálculos flotantes
# Calcular masa individual en la Entrada 1
Be_E1=$(echo "scale=4; $F1 * ($porc_Be1 / 100)" | bc)
THC_E1=$(echo "scale=4; $F1 * ($porc_THC1 / 100)" | bc)

# Calcular masa individual en la Entrada 2
Be_E2=$(echo "scale=4; $F2 * ($porc_Be2 / 100)" | bc)
THC_E2=$(echo "scale=4; $F2 * ($porc_THC2 / 100)" | bc)

# 3. Balance Total (Entrada Total = Salida Total)
F_salida=$(echo "scale=4; $F1 + $F2" | bc)

# Balance por componente (Masa Total Componente = Comp_E1 + Comp_E2)
Be_salida=$(echo "scale=4; $Be_E1 + $Be_E2" | bc)
THC_salida=$(echo "scale=4; $THC_E1 + $THC_E2" | bc)

# Calcular los porcentajes finales en la corriente de salida
porc_Be_salida=$(echo "scale=2; ($Be_salida / $F_salida) * 100" | bc)
porc_THC_salida=$(echo "scale=2; ($THC_salida / $F_salida) * 100" | bc)

# 4. Mostrar Resultados
mostrar_titulo
echo "==================== RESULTADOS DEL BALANCE ===================="
echo "Corriente de Salida Total estimada: $F_salida unidades"
echo "----------------------------------------------------------------"
echo "-> BERILIO (Be):"
echo "   - Masa total en la salida: $Be_salida unidades"
echo "   - Concentración final:     $porc_Be_salida %"
echo ""
echo "-> THC:"
echo "   - Masa total en la salida: $THC_salida unidades"
echo "   - Concentración final:     $porc_THC_salida %"
echo "================================================================"
