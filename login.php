<?php 
ini_set("session.gc_maxlifetime",600);	//600
ini_set("session.gc_probability",1);
ini_set("session.gc_divisor",1); 
ini_set("max_execution_time",350); // according email send
// session_cache_expire(30);
//ini_set('session.save_path',__DIR__.'/sess');

@session_name("bms3");
@session_start();

if(isset($_SESSION["authenticated"])){
	header("Location: ./index.php"); exit;
}

include_once("function.php");
include_once("lib/Smarty/libs/Smarty.class.php");
$smarty = new Smarty; //$db->debug=true;
$error = false;

if(isset($_POST["login_x"])){
	$data = validateInput($_POST, array('username','password'));  //echo"<br>VALIDATE : <pre>";print_r($data);echo"</pre>"; //die();
	if($data['error']) $error = $data['error'];
	$smarty->assign("username", $data['username'],true);
	

  if(!$error){  
		/** Validasi Level 2: LDAP Authentication */	
		//$ldap = ldap_connect("10.98.195.14");
		//$ldap = ldap_connect("JAKASPDOM01");
		//$userid = "apac\\".$data['username'];
		//$password=$data['password'];
		//$bind = ldap_bind($ldap, $userid, $password);
		                                               
																									////echo "ldap->".$ldap."  userid->".$userid."  password->".$password."  bind-->".$bind; die();
		//if(!$bind){
			//$error = $error . "Invalid username or password<br>";
		//}																			
		//if($error!= ""){
			//$smarty->assign("msg", setMsg($error, 'ui-state-error',null,null,'ui-icon-alert'),true); 
			//$smarty->assign("year", date('Y'),true); 
			//$smarty->display( "login.tpl" );
			//exit();
		//} 

		/** Validasi Level 3: Username harus ada di table user_list */
		$db = getDb();
		$sql = "SELECT id,fullname,status,dept,sign,position,spv,priviledges FROM userlist WHERE username='{$data['username']}'" ;
		$ADODB_FETCH_MODE = ADODB_FETCH_ASSOC;
		$rs = $db->_Execute($sql);
		if(!$rs){
			$error = $db->ErrorMsg();
		}else{									
			$user = $rs->fields; 
			if(!$user){ 
				$error = "You do not have access to this system";
				$db->_query("insert into userlog (date,userid,event) values ('" . date("Y-m-d H:i:s") . "','0', 'Failed login with username:$data[username]')");
			}elseif($user['status']==1){
				$error = "Username ".$username." is inactive";
			}else{
				$_SESSION["user"]= $user;
				$_SESSION["user"]["authenticated"]= 1;
			}			
		}
	}
}

function getmenu($units, $isHistorian=false){  //echo count($units)."<pre>";print_r($units);echo"</pre>";die();	
	if(count($units)==1){
    $priv=str_replace('"','',$_SESSION["user"]["priviledges"]);
		$menu = getlink($priv, $units[$priv]['units']);		
	}else{
		if($_SESSION["user"]["position"]=='admin'){
			$menu['Administrator'] = array(
				array('url'=>"backup.php",'label'=>'Backup','id'=>'backup'),
				array('url'=>"db_monitor.php",'label'=>'Data Base Monitoring','id'=>'db_monitor'),
				array('url'=>"users.php",'label'=>'User Management','id'=>'users'),
				array('url'=>"userlog.php",'label'=>'Users Log','id'=>'userlog'),
				//array('url'=>"tagtime.php",'label'=>'Set Capture Time','id'=>'tagtime'),
				array('url'=>"tagexport.php",'label'=>'Export Tags Data','id'=>'tagexport'),
				array('url'=>"emailUtil.php",'label'=>'Email Configurations','id'=>'emailUtil'),
				array('url'=>"report.php?r=adm",'label'=>'Report Lists','id'=>'report-adm'),
				array('url'=>"historian.php",'label'=>'Historian','id'=>'historian'),
			);
			$units['qo']['units'] = array_merge($units['qa']['units'], $units['qo']['units']);  
			unset($units['qa']); //echo "<pre>";print_r($x); print_r($units);echo"</pre>";die();
			foreach($units as $k=>$dept){
				$menu[$dept['label']] = getlink($k, $dept['units'], $isHistorian);
			}
		}
		else if($_SESSION["user"]['dept']=='qa' || $_SESSION["user"]['dept']=='qo'&&preg_match('/qa/', $_SESSION["user"]["priviledges"])){
			$units['qo']['units'] = array_merge($units['qa']['units'], $units['qo']['units']);  
			unset($units['qa']); 
			$menu = getlink('qo', $units['qo']['units']);		//echo "<pre>";print_r($x); print_r($units); print_r($menu);echo"</pre>";die();
		}else{ 
			foreach($units as $k=>$dept){
				$menu[$dept['label']] = getlink($k, $dept['units']);
			}	
		}
	} //echo "<pre>";print_r($_SESSION["user"]["priviledges"]); print_r($menu);echo"</pre>";//die();
	return $menu;
}

function getlink($dept, $units, $isHistorian){
	$menu=array();
	foreach($units as $k=>$v){
		$path = $isHistorian ? "historian.php?unit=$k" : "reporting.php?unit=$k";
		$menu[] = array('url'=>$path,'label'=>$v, 'id'=>$k);
	}
	return array_merge($menu, array(array('url'=>"report.php?r=$dept",'label'=>'Report Lists','id'=>'report-'.$dept)));
}
		
if($_SESSION && $_SESSION["user"]["authenticated"]){
//   echo "<pre>";print_r($_SESSION);echo"</pre>"; die();
  if(empty($_SESSION["user"]['menu'])){
    $_SESSION['units']=unitStore($db); //echo "UNITS <pre>";print_r($_SESSION['units']);echo"</pre>"; die();
    $units = ($_SESSION["user"]["position"]=='admin') ? getUnits() : getUnits(true); //echo count($units)."<pre>";print_r($units);echo"</pre>"; //die();
    $_SESSION["user"]['menu'] = getmenu($units);		//echo "<b>SESSION : </b> <pre>"; print_r($_SESSION);	echo "</pre>"; die();
    // if($_SESSION["user"]["position"]=='admin'){
		if($_SESSION["user"]["position"]=='admin' || $_SESSION["user"]["fullname"]=='initiator engineering 1'){
			$_SESSION["user"]['menu_his'] = getmenu($units, 1);
		}
		getMailCfg($db); # VIA DB
    usrlog("Login", $db );
  }
	header("Location: ./index.php");
}
$error = ($error) ? setMsg($error, 'ui-state-error',null,null,'ui-icon-alert') : null;
$smarty->caching = true;
$smarty->cache_lifetime = 2592000;
$smarty->assign("msg", $error,true); 
$smarty->assign("year", date('Y'),true); 
$smarty->display("login.tpl");
?>
