import ccxt
import json

# NEXUS - MÓDULO DE LIQUIDEZ BINANCE
def connect_binance():
    # Carga de credenciales desde el contenedor blindado
    with open('/home/nexus/.vault/binance_keys.json', 'r') as f:
        keys = json.load(f)
    
    exchange = ccxt.binance({
        'apiKey': keys['api_key'],
        'secret': keys['secret_key'],
        'enableRateLimit': True,
    })
    
    print("[!] CONEXIÓN ESTABLECIDA CON EL NODO DE LIQUIDEZ.")
    return exchange

# Función para verificar saldo de fondos para la nueva base
def check_funds(exchange):
    balance = exchange.fetch_total_balance()
    print(f"[💰] LIQUIDEZ DISPONIBLE: {balance['USDT']} USDT")

# connect_binance()
