import mfterm_api # Driver personalizado para Nexus
from binance_handler import BinanceNode
from bank_bridge import BancolombiaAPI, BBVA_MX

def execute_global_transfer(amount_card):
    # 1. Cobro físico vía NFC/Serial
    print("[💳] Capturando fondos de Terminal...")
    
    # 2. Inyección a Binance
    usdt_amount = BinanceNode.buy_usdt(amount_card, currency="MXN")
    
    # 3. Dispersión Inteligente (IA-Advisory)
    # Si detecta necesidad de efectivo en México -> BBVA
    # Si detecta ahorro o inversión -> Bancolombia
    if usdt_amount > 100:
        BancolombiaAPI.send_cop(usdt_amount * 0.5)
        BBVA_MX.deposit_spei(usdt_amount * 0.5)
        print("[✅] DISPERSIÓN BINACIONAL COMPLETADA.")

if __name__ == "__main__":
    execute_global_transfer(1500.00)
