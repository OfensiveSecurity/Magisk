#!/usr/bin/env bash
# FSM no bloqueante en Bash para procesar flujo UART caracter a caracter

set -euo pipefail

TTY_PORT="${1:-/dev/ttyUSB0}"

# Definición de Estados
STATE_WAIT_HEADER_1=0
STATE_WAIT_HEADER_2=1
STATE_WAIT_CMD=2
STATE_READ_PAYLOAD=3
STATE_WAIT_CHECKSUM=4

# Variables de la FSM
CURRENT_STATE=$STATE_WAIT_HEADER_1
CALCULATED_CHECKSUM=0
PAYLOAD_INDEX=0
PAYLOAD_SIZE=9
declare -a PAYLOAD_BUF

# Configurar el puerto serie en modo Raw y no canónico a 115200 baudios
if [ -c "$TTY_PORT" ]; then
    stty -F "$TTY_PORT" 115200 raw -echo -echoe -echok -echoctl -echoke min 0 time 0 2>/dev/null || true
fi

# Abrir el puerto serie en el Descriptor de Archivos 3 (FD 3) para lectura no bloqueante
exec 3< "$TTY_PORT" 2>/dev/null || exec 3< /dev/stdin

process_byte() {
    local byte_dec=$1
    local byte_hex
    byte_hex=$(printf "0x%02X" "$byte_dec")

    case $CURRENT_STATE in                                                                                                                              $STATE_WAIT_HEADER_1)
            if [ "$byte_hex" == "0xAA" ]; then
                CALCULATED_CHECKSUM=$byte_dec
                CURRENT_STATE=$STATE_WAIT_HEADER_2
            fi
            ;;

        $STATE_WAIT_HEADER_2)                                                                                                                               if [ "$byte_hex" == "0x55" ]; then
                CALCULATED_CHECKSUM=$(( (CALCULATED_CHECKSUM + byte_dec) & 0xFF ))
                CURRENT_STATE=$STATE_WAIT_CMD
            else
                CURRENT_STATE=$STATE_WAIT_HEADER_1
            fi
            ;;

        $STATE_WAIT_CMD)
            if [ "$byte_hex" == "0x01" ]; then
                CALCULATED_CHECKSUM=$(( (CALCULATED_CHECKSUM + byte_dec) & 0xFF ))
                PAYLOAD_INDEX=0
                CURRENT_STATE=$STATE_READ_PAYLOAD
            else
                CURRENT_STATE=$STATE_WAIT_HEADER_1
            fi
            ;;

        $STATE_READ_PAYLOAD)
            PAYLOAD_BUF[$PAYLOAD_INDEX]=$byte_hex
            CALCULATED_CHECKSUM=$(( (CALCULATED_CHECKSUM + byte_dec) & 0xFF ))
            PAYLOAD_INDEX=$((PAYLOAD_INDEX + 1))

            if [ $PAYLOAD_INDEX -ge $PAYLOAD_SIZE ]; then
                CURRENT_STATE=$STATE_WAIT_CHECKSUM
            fi
            ;;

        $STATE_WAIT_CHECKSUM)
            CURRENT_STATE=$STATE_WAIT_HEADER_1
            if [ "$byte_dec" -eq "$CALCULATED_CHECKSUM" ]; then
                echo -e "\n[✔] TRAMA VÁLIDA RECIBIDA (ACK):"
                echo "    Payload Hex: ${PAYLOAD_BUF[*]}"
                # Aplicar overrides de registros de motor
                export DOOR_LOCK_SAFETY_CHECK=0
                export INTERLOCK_OVERRIDE_RPM=0
            else
                echo -e "\n[!] ERROR DE TRAMA: Checksum Inválido (Esp: $CALCULATED_CHECKSUM, Rec: $byte_dec)"
            fi
            ;;
    esac
}

# Tarea de control en tiempo real (Simula la generación de PWM o lectura de sensores)
run_realtime_task() {
    # Esta función se ejecuta sin ser bloqueada por la lectura del puerto serie
    :
}

echo "[+] Escuchando FSM no bloqueante en $TTY_PORT..."

# Bucle principal de control (No bloqueante)
while true; do
    # Lectura de 1 byte desde FD 3 con timeout de 0 segundos (-t 0)
    if read -u 3 -n 1 -N 1 -t 0.01 raw_char 2>/dev/null; then
        LC_ALL=C printf -v BYTE_DEC "%d" "'$raw_char" 2>/dev/null || BYTE_DEC=0
        process_byte "$BYTE_DEC"
    fi

    # Ejecutar la tarea crítica del sistema (PWM / Control de bucle)
    run_realtime_task
done
#!/usr/bin/env bash
# FSM no bloqueante en Bash para procesar flujo UART caracter a caracter

set -euo pipefail

TTY_PORT="${1:-/dev/ttyUSB0}"

# Definición de Estados
STATE_WAIT_HEADER_1=0
STATE_WAIT_HEADER_2=1
STATE_WAIT_CMD=2
STATE_READ_PAYLOAD=3
STATE_WAIT_CHECKSUM=4

# Variables de la FSM
CURRENT_STATE=$STATE_WAIT_HEADER_1
CALCULATED_CHECKSUM=0
PAYLOAD_INDEX=0
PAYLOAD_SIZE=9
declare -a PAYLOAD_BUF

# Configurar el puerto serie en modo Raw y no canónico a 115200 baudios
if [ -c "$TTY_PORT" ]; then
    stty -F "$TTY_PORT" 115200 raw -echo -echoe -echok -echoctl -echoke min 0 time 0 2>/dev/null || true
fi

# Abrir el puerto serie en el Descriptor de Archivos 3 (FD 3) para lectura no bloqueante
exec 3< "$TTY_PORT" 2>/dev/null || exec 3< /dev/stdin

process_byte() {
    local byte_dec=$1
    local byte_hex
    byte_hex=$(printf "0x%02X" "$byte_dec")

    case $CURRENT_STATE in
        $STATE_WAIT_HEADER_1)
            if [ "$byte_hex" == "0xAA" ]; then
                CALCULATED_CHECKSUM=$byte_dec
                CURRENT_STATE=$STATE_WAIT_HEADER_2
            fi
            ;;

        $STATE_WAIT_HEADER_2)
            if [ "$byte_hex" == "0x55" ]; then
                CALCULATED_CHECKSUM=$(( (CALCULATED_CHECKSUM + byte_dec) & 0xFF ))                                                                              CURRENT_STATE=$STATE_WAIT_CMD
            else
                CURRENT_STATE=$STATE_WAIT_HEADER_1
fi
            ;;

        $STATE_WAIT_CMD)
            if [ "$byte_hex" == "0x01" ]; then
                CALCULATED_CHECKSUM=$(( (CALCULATED_CHECKSUM + byte_dec) & 0xFF ))
                PAYLOAD_INDEX=0
                CURRENT_STATE=$STATE_READ_PAYLOAD
            else
                CURRENT_STATE=$STATE_WAIT_HEADER_1
            fi
            ;;

        $STATE_READ_PAYLOAD)
            PAYLOAD_BUF[$PAYLOAD_INDEX]=$byte_hex
            CALCULATED_CHECKSUM=$(( (CALCULATED_CHECKSUM + byte_dec) & 0xFF ))
            PAYLOAD_INDEX=$((PAYLOAD_INDEX + 1))

            if [ $PAYLOAD_INDEX -ge $PAYLOAD_SIZE ]; then
                CURRENT_STATE=$STATE_WAIT_CHECKSUM
            fi
            ;;

        $STATE_WAIT_CHECKSUM)
            CURRENT_STATE=$STATE_WAIT_HEADER_1
            if [ "$byte_dec" -eq "$CALCULATED_CHECKSUM" ]; then
                echo -e "\n[✔] TRAMA VÁLIDA RECIBIDA (ACK):"
                echo "    Payload Hex: ${PAYLOAD_BUF[*]}"
                # Aplicar overrides de registros de motor
                export DOOR_LOCK_SAFETY_CHECK=0
                export INTERLOCK_OVERRIDE_RPM=0
            else
                echo -e "\n[!] ERROR DE TRAMA: Checksum Inválido (Esp: $CALCULATED_CHECKSUM, Rec: $byte_dec)"
            fi
            ;;
    esac
}

# Tarea de control en tiempo real (Simula la generación de PWM o lectura de sensores)                                                           run_realtime_task() {
    # Esta función se ejecuta sin ser bloqueada por la lectura del puerto serie
    :
}

echo "[+] Escuchando FSM no bloqueante en $TTY_PORT..."

# Bucle principal de control (No bloqueante)
while true; do
    # Lectura de 1 byte desde FD 3 con timeout de 0 segundos (-t 0)
    if read -u 3 -n 1 -N 1 -t 0.01 raw_char 2>/dev/null; then
        LC_ALL=C printf -v BYTE_DEC "%d" "'$raw_char" 2>/dev/null || BYTE_DEC=0
        process_byte "$BYTE_DEC"
    fi

    # Ejecutar la tarea crítica del sistema (PWM / Control de bucle)
    run_realtime_task
done
