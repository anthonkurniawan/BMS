<?php                                      
include("verifyLogin.php");
require("lib/Smarty/libs/Smarty.class.php");
include("function.php");
//include("connect.php");

$smarty=new Smarty; //$smarty->debugging=true;
//$smarty->caching=true;
//$smarty->cache_lifetime=2592000;
// retain current cache lifetime for each specific display call
$smarty->setCaching(Smarty::CACHING_LIFETIME_SAVED);
// set the cache_lifetime for index.tpl to 5 minutes
$smarty->setCacheLifetime(300);
$smarty->setCompileCheck(false);

//echo "<pre>"; print_r($smarty);  echo "</pre>"; die();
																																										
$priv=getPriv(true); //echo"<b>priv :</b>";print_r($priv); die();
$cacheid=($_SESSION['user']['position']=='admin') ? 'admin' : $_SESSION['user']['priviledges'];  //echo "<pre>"; print_r($_SESSION);echo "</pre>";  echo "CACHE-ID: $cacheid";die();
$smarty->assign("menu", array('list'=>$_SESSION['user']["menu"],'chid'=>$cacheid));
//$smarty->assign("menu", array('list'=>$_SESSION['user']["menu"]), true);
$smarty->assign("msg",getMsg(),true);
$smarty->assign("user", array("fname"=>ucwords($_SESSION['user']["fullname"]),"privilege"=>(is_array($priv)?implode(', ', $priv):$priv)));
$smarty->display("index.tpl");
?>
