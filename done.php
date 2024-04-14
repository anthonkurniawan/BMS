<?php
include("verifyLogin.php");
require("lib/Smarty/libs/Smarty.class.php");
include("function.php");

$smarty=new Smarty;
$smarty->caching=true;
$smarty->cache_lifetime=86400;

$data=null;
$msg=isset($_GET['msg']) ? $_GET['msg'] : "What are you looking for?";
if($msg) $data['msg'] = setMsg($msg,'ui-state-error',null,"padding:20px 10px;font-size:20px;width:550px;margin-top:200px",'ui-icon-alert');

$smarty->assign("menu", array('list'=>$_SESSION['user']["menu"],'chid'=>($_SESSION['user']['position']=='admin') ? 'admin' : $_SESSION['user']['priviledges']));
$smarty->assign("data", $data, true); 
$smarty->assign("page", array('title'=>'BMS-Done','content'=>"done.tpl"),true);
$smarty->display("layout.tpl");
?>
