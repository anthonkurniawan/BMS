<?php
include( "../connect.php" );

$res = $db->execute('getUsers')->GetArray();
//$res = $db->executeQuery('call getUsers');
//$res = $db->prepareSP('call getUsers');
echo "----->"; print_r($res);
?>