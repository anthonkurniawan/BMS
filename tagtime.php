<?php
include("verifyLogin.php");
if($_SESSION['user']['position']!=='admin') header("location: ./noPrivilege.php");
 
require("lib/Smarty/libs/Smarty.class.php");
include("function.php");
$smarty=new Smarty; //$db->debug=true;
$smarty->caching=true;
$smarty->cache_lifetime=86400;

$rs=$db->CacheGetOne(86400, "SELECT time FROM tagtime");
if(!$rs)
	$error=$db->ErrorMsg();
else
	$data['time']=array('select'=>$rs,'current'=>($rs/60)." Minutes");
			
if($_POST['time']){
	if(!$_POST['time']['select'])
		$error= "Please Insert Tagtime!</br>";
	if($_POST['time']['select']=='other'){
    $data['time']['oth'] = $_POST['time']['oth']; 
		if(is_numeric($data['time']['oth'])&&$data['time']['oth']>=30){
			$time = $data['time']['oth'] * 60;
		}else
			$error="Please Insert Tagtime in numeric And not less than 30minutes !</br>";
	}
	else{$time=$_POST['time']['select'];}
	
	if(!$error){
		$rs = $db->_query("UPDATE tagtime SET time ='".$time."'"); 
		if(!$rs)
			$error = $db->ErrorMsg();
		else{
			$data['time']['select']=$time;
			$data['time']['current']=($time/60)." Minutes";
			$info="New Setting Tagtime Time to ".$data['time']['current'];
			usrlog($info, $db);
			$db->CacheFlush("SELECT time FROM tagtime");
		}
	}
}
else usrlog("Access tagtime time setting", $db);

if($error){
	$data['msg']['error']=setMsg("<b>Failed get setting interval tagtime:</b><br>".$error, 'ui-state-error',null,null,'ui-icon-alert');
}
if($info){
	$data['msg']['info']=setMsg($info, 'ui-state-highlight',null,null,'ui-icon-info');
}//echo"<pre>";print_r($data);echo"</pre>";//die();		
$smarty->assign("data",$data, true);
$smarty->assign("menu",array('list'=>$_SESSION['user']["menu"],'chid'=>($_SESSION['user']['position']=='admin')?'admin':$_SESSION['user']['priviledges']));
$smarty->assign("page",array('title'=>'BMS-Tagtime&nbsp;&nbsp;Setting','content'=>"tagtime.tpl"),true);
$smarty->display("layout.tpl" );  
?>
