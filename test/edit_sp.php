<?php
include( "../connect.php" );

$q = "
ALTER PROCEDURE
getUsers
AS
SELECT * FROM userlist WHERE id=12
 ";

$res = $db->execute($q);
//$res = $db->executeQuery('call getUsers');
//$res = $db->prepareSP('call getUsers');
echo "----->"; print_r($res);
echo "<br> error : " . $db->ErrorMsg();
?>