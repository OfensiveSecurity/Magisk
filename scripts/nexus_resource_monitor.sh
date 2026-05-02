#!/bin/bash
# MONITOR DE RECURSOS TÁCTICOS v1.0

while true; do
    # 1. Uso de CPU (Carga de los 8 núcleos)
    CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    
    # 2. RAM Libre (Crucial para Metasploit/Nmap)
    RAM_FREE=$(free -m | awk '/Mem:/ { print $4 }')
    RAM_TOTAL=$(free -m | awk '/Mem:/ { print $2 }')
    
    # 3. Procesos de Ataque Activos
    ATTACK_PROCS=$(pgrep -f "nmap|msfconsole|hydra|responder" | wc -l)

    # 4. Inyección a Archivo de Log para Flask
    echo "CPU:$CPU_LOAD% | RAM_FREE:${RAM_FREE}MB/${RAM_TOTAL}MB | ACTIVE_ATTACKS:$ATTACK_PROCS" > ~/nexus/logs/vitals.tmp
    
    sleep 1
done
