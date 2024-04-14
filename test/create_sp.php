<?php
include( "../connect.php" );

$q = "ALTER PROCEDURE
getUsers
AS 
SELECT * FROM userlist WHERE id=1
GO";

$res = $db->execute($q);
//$res = $db->executeQuery('call getUsers');
//$res = $db->prepareSP('call getUsers');
echo "----->"; print_r($res);
?>