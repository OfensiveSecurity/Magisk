#!/usr/bin/env python3
from itertools import product

OBJETIVO = "Kali18"

SISTEMAS = {
    "Termux": "LOCAL",
    "Kali": "LOCAL",
    "NetHunter": "LOCAL",
    "John": "AUDITORIA_LOCAL",
    "Ghidra": "ANALISIS_LOCAL",
    "Bootloader": "SIMULADO",
}

CARACTERES = "abcdefghijklmnopqrstuvwxyz0123456789"

def candidatos():
    # Primero candidatos pequeños y después combinaciones
    conocidos = [
        "123456", "password", "admin", "kali", "android",
        "nethunter", "Kali18"
    ]

    for x in conocidos:
        yield x

    for longitud in range(1, 7):
        for p in product(CARACTERES, repeat=longitud):
            yield "".join(p)

def mostrar_sistemas():
    print("\n=== SISTEMAS EN SIMULACIÓN ===")
    for nombre, estado in SISTEMAS.items():
        print(f"[OK] {nombre:<12} {estado}")

def main():
    mostrar_sistemas()
    print("\n=== SIMULADOR DE INTENTOS ===")
    print("Objetivo: contraseña ficticia local")
    print("Sin red / sin cuentas reales / sin bootloader real\n")

    intentos = 0

    for candidato in candidatos():
        intentos += 1

        print(
            f"\rIntento {intentos:06d} | "
            f"candidato={candidato:<12}",
            end="",
            flush=True
        )

        if candidato == OBJETIVO:
            print("\n\n[ENCONTRADA]")
            print(f"Contraseña de laboratorio: {candidato}")
            print(f"Intentos: {intentos}")
            break
    else:
        print("\n\n[NO ENCONTRADA]")

if __name__ == "__main__":
    main()