<?php
include("verifyLogin.php");
if($_SESSION['user']['position']!=='admin') header("location: ./noPrivilege.php");
 
require("lib/Smarty/libs/Smarty.class.php");
include("function.php");
$smarty=new Smarty;
//$db->debug=true; //$smarty->debugging=true;
$smarty->caching=true;
$smarty->cache_lifetime=86400;

$db = getDb();
$rs=getMailCfg($db); # VIA DB
if(!$rs)
	$data['msg']['error'] = setMsg("Error db email configuration :<br>".$db->ErrorMsg(), 'ui-state-error',null,null,'ui-icon-alert');
else{
	$data['email']=$rs; $rs=null;
}
	
if($_POST['kirim']){
	$_POST['Priority']=(int) $_POST['Priority'];
  $data['email'] = validateInput($_POST, array('Host','Port','From','FromName'));  //echo"<br>VALIDATE : <pre>";print_r($data);echo"</pre>"; //die();
	if($data['email']['error'])
		$data['msg']['error'] = setMsg($data['email']['error'], 'ui-state-error',null,null,'ui-icon-alert');
	else{
		$rs = $db->_query("UPDATE emailcfg set Host='{$data['email']['Host']}',Port='{$data['email']['Port']}',[From]='{$data['email']['From']}',FromName='{$data['email']['FromName']}',Priority='{$data['email']['Priority']}',ContentType='{$data['email']['ContentType']}',Timeout='{$data['email']['Timeout']}' where id=1"); // Host,Port,From,FromName,Priority,ContentType,Timeout 
		if(!$rs)
			$data['msg']['error'] = setMsg("Update email setting failed :<br>".$db->ErrorMsg(), 'ui-state-error',null,null,'ui-icon-alert');
		else{
			$info="Email Configuration Successfully Update";
			$data['msg']['info'] = setMsg($info, 'ui-state-highlight',null,null,'ui-icon-info');
			$db->CacheFlush("select * from emailcfg");
			usrlog("Update email setting :".$info, $db);
		}
	}
}else usrlog("Access Email Utilities", $db);
//echo"DATA : <pre>";print_r($data);echo"</pre>";//die();

$smarty->assign("data", $data,true);
$smarty->assign("menu", array('list'=>$_SESSION['user']["menu"],'chid'=>($_SESSION['user']['position']=='admin') ? 'admin' : $_SESSION['user']['priviledges']));
$smarty->assign("page", array('title'=>'BMS-Email&nbsp;&nbsp;Utilties','content'=>"emailUtil.tpl"), true);
$smarty->display("layout.tpl");  
?>
