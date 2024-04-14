<?php
include("verifyLogin.php");
include("function.php");
require("lib/Smarty/libs/Smarty.class.php");
$smarty=new Smarty;//$smarty->debugging=true;
$smarty->caching=true;
$smarty->cache_lifetime=86400;

$msg=setMsg("Sorry, You do not have a privilege to access this page",'ui-state-error',null,"width:600px;padding:20px 10px;font-size:20px;margin-top:200px",'ui-icon-alert');
$smarty->assign("data", array('msg'=>$msg), true);
$smarty->assign("menu", array('list'=>$_SESSION['user']["menu"],'chid'=>($_SESSION['user']['position']=='admin') ? 'admin' : $_SESSION['user']['priviledges']));
$smarty->assign("page", array('title'=>'BMS-No Priviledges','content'=>"done.tpl"), true);
$smarty->display("layout.tpl");
?>
