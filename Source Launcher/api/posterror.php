<?php
$log = base64_decode($_POST['d']);
file_put_contents('./log_'.date("j.n.Y").'.log', $log, FILE_APPEND);
?>