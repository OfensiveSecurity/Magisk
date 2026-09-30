#!/usr/bin/env python3
import csv
from datetime import datetime

ARCHIVO = "interferencias.csv"

def registrar(frecuencia, potencia, ruido):
    contraste = potencia - ruido

    if contraste < 3:
        clase = "normal"
    elif contraste < 10:
        clase = "posible_interferencia"
    else:
        clase = "interferencia_fuerte"

    fila = [
        datetime.now().isoformat(timespec="seconds"),
        frecuencia,
        potencia,
        ruido,
        contraste,
        clase,
    ]

    nuevo = False
    try:
        open(ARCHIVO).close()
    except FileNotFoundError:
        nuevo = True

    with open(ARCHIVO, "a", newline="") as f:
        w = csv.writer(f)
        if nuevo:
            w.writerow([
                "timestamp", "frecuencia",
                "potencia_dbm", "ruido_dbm",
                "contraste_db", "clasificacion"
            ])
        w.writerow(fila)

    print(f"[REGISTRO] {frecuencia} MHz | "
          f"{contraste:.1f} dB | {clase}")

print("=== REGISTRADOR PASIVO ===")
print("No transmite ni genera interferencias.")
print()

while True:
    try:
        f = input("Frecuencia MHz (q salir): ")
        if f.lower() == "q":
            break

        p = float(input("Potencia dBm: "))
        n = float(input("Ruido dBm: "))

        registrar(float(f), p, n)

    except ValueError:
        print("Entrada inválida.")