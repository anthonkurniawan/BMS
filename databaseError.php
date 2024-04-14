<?php
require( "lib/Smarty/libs/Smarty.class.php" );
$smarty = new Smarty;
$smarty->caching = true;
$smarty->cache_lifetime = 2592000;
$smarty->display( "databaseError.tpl" )
?>
