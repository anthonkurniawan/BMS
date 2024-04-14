<?php
include("verifyLogin.php");
if($_SESSION['user']['position']!=='admin') header("location: ./noPrivilege.php");
 
require("lib/Smarty/libs/Smarty.class.php");
include("function.php");

$smarty=new Smarty;//$db->debug=true;$smarty->debugging=true;
$smarty->caching=true;
$smarty->cache_lifetime=86400;
$db = getDb(); //$db->debug=true;
$ADODB_FETCH_MODE=ADODB_FETCH_ASSOC;

if($_GET['id']&&($id=(int)($_GET['id']))==0){
	header("location:done.php?msg=Invalid user-id"); exit;
}

$dir='images/sign/';
if($_POST){
	$id=$_POST['id'];
	$data['user']=validateInput($_POST, array('username','fullname','email','position'));  //echo"<br>VALIDATE : <pre>";print_r($data);echo"</pre>"; die();
	if($data['user']['error']){
		$error=array_pop($data['user']);
	}
	$data['user']['priv']=$_POST['priv'];$data['user']['spv']=$_POST['spv'];$_POST=null;
	
	if(!$error){
		if(!$id||$data['user']['username']!==$data['user']['usernameX']){
			$rs= $db->_Execute("SELECT username FROM userlist WHERE username ='".$data['user']['username']."'");
			if($rs->fields){$error="Username allready exist !"; }
		}
		if(!$error){
			if($_FILES["pic"]["error"]==0){
				$ext=substr($_FILES['pic']['name'] , strrpos($_FILES['pic']['name'] , '.') +1);
				$file=$data['user']['username'].".".$ext; 
				$path=$dir.$file;
					
				if($upload=move_uploaded_file($_FILES['pic']['tmp_name'], $path)){
					$data['user']['sign']=$file;
					$info[]="Sign picture successfully uploaded";
				}else
					$error[]="error uploading the sign picture, please try again!";
			}
      $privs=str_replace('%22','"',implode(',',array_keys($data['user']['priv'])));  //print_r($data['user']['priv']); echo "-->". str_replace('%22','"', $privs); //die();
			$spvs=(array_sum($data['user']['spv'])!=0) ? trim(implode(",",$data['user']['spv']),",") : null; //echo "privs : $privs spvs: $spvs";die();
			
			if($id){
				$q= "update userlist set username='{$data['user']['username']}',fullname='{$data['user']['fullname']}',email='{$data['user']['email']}',dept='{$data['user']['dept']}',position='{$data['user']['position']}',sign='{$data['user']['sign']}',priviledges='{$privs}',spv='{$spvs}' WHERE id={$id}";
			}else{
				$id=getLastPk($db,'userlist');
				$data['user']['id']=$id;
				//$q="Set IDENTITY_INSERT userlist ON;insert into userlist (id, username,fullname,email,dept,position,sign,spv,priviledges,status) values ($id,'{$data['user']['username']}','{$data['user']['fullname']}','{$data['user']['email']}','{$data['user']['dept']}','{$data['user']['position']}','{$data['user']['sign']}','{$spvs}','{$privs}',2);Set IDENTITY_INSERT userlist OFF";
				// MYSQL TEST
				$q="insert into userlist (id, username,fullname,email,dept,position,sign,spv,priviledges,status) values ($id,'{$data['user']['username']}','{$data['user']['fullname']}','{$data['user']['email']}','{$data['user']['dept']}','{$data['user']['position']}','{$data['user']['sign']}','{$spvs}','{$privs}',2);";
			}

			if(!$db->_Execute($q)){
				$error[]=$db->ErrorMsg();
				if($upload) unlink($path); 
				$data['user']['sign']=null;
			}else{
				$info[]=($_GET['id']) ? "Update user \"{$data['user']['username']}\" successfully":"New User \"{$data['user']['username']}\" succesfully added to database";
				usrlog($info, $db);
				$_SESSION['user']['msg']=$info;
				if(!$error){
					header("location: users.php"); exit; 
				}
			}
		}
	}
}
# EDIT
elseif($_GET['id']){
	$id = $_GET['id']; 
	$rs=$db->_Execute("SELECT * FROM userlist WHERE id=$id");
	if(!$rs->fields){
		header("location:done.php?msg=User doesn't exist!"); exit;
	}else{
		$data['user']=$rs->fields;
    if(!is_file($dir.$data['user']['sign'])) $data['user']['sign']=null; 
		$data['user']['priv']=array_flip(explode(',',str_replace('"','',$rs->fields['priviledges'])));  //print_r($data['user']['priv']); print_r(array_flip($data['user']['priv']));die();
	}	
}

$data['act']= ($_GET['id']) ? "Edit User #".$data['user']['username'] : 'Create New User';
if($data['user']['position']=='int'){
	$data['user']['spv']=spvVal($data['user']['spv']);
	$data['user']['spvOpt']=spvOpts($db, $data['user']['priviledges']); 
}
$data["depts"]=deptLabel();

if($error){
	$data['msg']['error']=setMsg($error, 'ui-state-error',null,null,'ui-icon-alert');
}
//echo"<pre>";print_r($data); echo"</pre>";//die();
$data['msg']['info']=getMsg();
$smarty->assign("data", $data, true);
$smarty->assign("menu", array('list'=>$_SESSION['user']["menu"],'chid'=>($_SESSION['user']['position']=='admin') ? 'admin' : $_SESSION['user']['priviledges']));
$smarty->assign("page", array('title'=>'BMS-'.str_replace(" ", "&nbsp;&nbsp;", $data['act']),'content'=>"userform.tpl"), true);
$smarty->display("layout.tpl");
usrlog($data['act'], $db);

function spvOpts($db, $priviledges){ 
  $rs=$db->_Execute("select id,username from userlist where status=2 and dept in(". $priviledges.") and position='spv'");
  if($rs)	return $rs->GetAssoc();
}

function spvVal($spv, $str=true){
	if($str)return is_string($spv) ? explode(',', $spv) : $spv;
	else return is_array($spv) ? implode(',', $spv) : $spv;
}
?>
