<?php
include("verifyLogin.php");
require("lib/Smarty/libs/Smarty.class.php");
include("function.php");

$smarty=new Smarty;
$smarty->caching=true;
$smarty->cache_lifetime=86400;

$data['msg'] = setMsg("BMS Ver 3.0",'ui-state-default',null,"padding:20px 10px;font-size:20px;width:550px;margin-top:200px",'ui-icon-info');

$smarty->assign("menu", array('list'=>$_SESSION['user']["menu"],'chid'=>($_SESSION['user']['position']=='admin') ? 'admin' : $_SESSION['user']['priviledges']));
$smarty->assign("data", $data, true); 
$smarty->assign("page", array('title'=>'BMS-About','content'=>"done.tpl"),true);
$smarty->display("layout.tpl");
?>
