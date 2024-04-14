<?php
//include( "../connect.php" );

//$res = $db->execute($q);
//echo "<br> error : " . $db->ErrorMsg();

$tpl = "sources/input.php";
$output = "output/output.php";

if(! file_exists($tpl))
    echo  "Template source not exists !";   
else{
    $source = file_get_contents($tpl); 
    echo htmlspecialchars($source); //die();
    echo file_put_contents($output, "aaa<br>bbb\nccc\n\tffff");  // save code to file
}
?>
