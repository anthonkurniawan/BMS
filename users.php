<?php
include("verifyLogin.php");

if($_SESSION['user']['position']!=='admin') header("location: ./noPrivilege.php");
include("function.php");
$ADODB_FETCH_MODE=ADODB_FETCH_ASSOC;
$db = getDb(); //$db->debug=true;

if($_POST['act'])
{
	$id=$_POST['id'];
	$act= $_POST['act'];
	if(!$act && !$id)
		$error="user id is empty";
	else{
		if($act=='active'){
			$rs=$db->_query("update userlist set status=2 where id=$id");
		}elseif($act=='inactive'){
			$rs=$db->_query("update userlist set status=1 where id=$id");
		}
		if(!$rs)
			$error=str_replace("'",'"',$db->ErrorMsg());
		else $msg="userid:$id is $act";
	}
	usrlog("$act user id:".$id." ".(($error)?"failed:$error":"success"),$db);
	$msg=($error) ? array('error'=>$error) : $msg;
	echo json_encode($msg);
	die();
}
else
{
	require("lib/Smarty/libs/Smarty.class.php");
	$smarty=new Smarty; //$db->debug=true;
	$smarty->caching=true;
	$smarty->cache_lifetime=86400;

	if($_POST['q']){ 
		$sql=buildQuery($_POST['q'],array('dept'=>'dept','pos'=>'position','st'=>'status','uname'=>'username','fname'=>'fullname','email'=>'email','priv'=>'priviledges'));
		$query="SELECT id, username, fullname, email, dept, position, sign, replace(priviledges,'\"','') as priviledges, status FROM userlist $sql[q] ORDER BY username ASC";
	}else{
		$query="SELECT id, username, fullname, email, dept, position, sign, replace(priviledges,'\"','') as priviledges, status FROM userlist";
	}

	$rs=getPager($db,$query,12,$_POST['print']); //echo"<pre>";print_r($rs);echo"</pre>";die();
	
	if($rs['error']){
		$msg=$rs['error'];
	}else{
		$data['users']=$rs['rs']->getArray();
		$data['pager']=$rs['pager'];
		$data['count']=$rs['totalCount'];
		$data['pages']=$rs['pageCount'];
		$rs['rs']->Close();	
		$rs=null;  //echo"<pre>";print_r($data['users']); echo"</pre>";die();
		
		if(count($data['users'])==0)
			$msg='Report Empty';
	}
	$smarty->registerPlugin("function","dept","getDept");
	
	if($_POST['print']){
		//usrlog("Print User Management",$db);
		$smarty->assign("q",array('print'=>1),true);
		$smarty->assign("data",$data,true);
		$html=$smarty->fetch("users.tpl"); //echo "RESULT : $html"; die();
		$colsAtr=array('F'=>array('align'=>'C'),'C'=>array('width'=>'AT'),'D'=>array('width'=>'AT'));
		$setting=array('label'=>"User Management",'headRows'=>2,'colsAtr'=>$colsAtr);
		printXls($html,$data['pages'] ." of ". $data['count']." Records",$setting);
	}
	else{
		$data['msg']['info']=getMsg();
		$data['msg']['error']=($msg) ? setMsg($msg,'ui-state-error',null,null,'ui-icon-alert') : null; //echo "<pre>";print_r($data);echo"</pre>";//die();
		$smarty->assign("data",$data,true);
		$q=array('depts'=>deptLabel(),'page'=>$_POST['r_page']);
			if(isset($sql['qval']))
		$q=array_merge($q,$sql['qval']);
		$smarty->assign("q",$q,true);
		$smarty->assign("page",array('title'=>"BMS-User&nbsp;&nbsp;Management",'content'=>"users.tpl"),true);
		$smarty->assign("menu",array('list'=>$_SESSION['user']["menu"],'chid'=>($_SESSION['user']['position']=='admin') ? 'admin' : $_SESSION['user']['priviledges']));
		$smarty->display("layout.tpl");
		//usrlog("Access User Management",$db);
	} 
}
?>
