<?php
require("lib/Smarty/libs/Smarty.class.php");
include( "function.php");
 
session_name("bms3");
session_start();
session_destroy();

usrlog("logout", $db);
$smarty = new Smarty;
$smarty->caching = true;
$smarty->cache_lifetime = 2592000;
$smarty->assign("year", date('Y'),true); 
$smarty->display("logout.tpl");
?>
