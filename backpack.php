<?php
if ($_POST['action'] == 'start_monitor') {
    // Ejecuta el monitor en segundo plano usando sudo/tsu
    // Redirigimos la salida a un log para que no bloquee la web
    shell_exec("su -c 'airmon-ng start wlan0 > /sdcard/www/monitor.log 2>&1 &'");
    echo "Monitor Iniciado";
}
?>
