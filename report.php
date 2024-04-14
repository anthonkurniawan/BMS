<?php
include_once("verifyLogin.php");
include_once("lib/Smarty/libs/Smarty.class.php");
include_once("function.php");

$smarty=new Smarty;					//echo "<pre>";print_r($_SESSION['user']['priviledges']);echo"</pre>";die();
$smarty->caching=true;
$smarty->cache_lifetime=86400;

$usrdept=$_SESSION['user']["dept"];	
$usrpos=getPosCode();
$deptR=$_GET['r'];
$dept=($deptR!='adm') ? $deptR:null;
// $deptPriv = '"'. str_replace(',', '","', $_SESSION['user']['priviledges']) . '"';
//count(explode(',', $_SESSION['user']['priviledges']))
if($usrpos=='admin'&& $deptR=='adm'){
	$priv=true;
}else{
	$priv=accesspriv($dept);
}
if(!$priv) header("location: ./noPrivilege.php"); 

$_SESSION['r_curr_page'] = null;  //echo "<pre>";print_r($_SESSION['r_curr_page']);echo"</pre>";
if($_POST['q']){  //echo "<pre>";print_r($_POST['q']);echo"</pre>";
	$sql=buildQuery($_POST['q'], array('dept'=>'dept','unit'=>'unit','st'=>'status','fname'=>'fullname','email'=>'email','priv'=>'priviledges','dt'=>'date','ds'=>'date','de'=>''));  //echo"BUILD QUERY:";print_r($sql); //die();
}
$sql['q']=($sql['q']) ? $sql['q'] : (($dept) ? "WHERE dept in(".preg_replace('/"/',"'",$_SESSION['user']['priviledges']).")" :"");  //echo "<br>QVAL: "; print_r($sql['qval']);  var_dump(!$sql['qval']['dept']=='all');

if($usrpos=='admin'){
	$query=$sql['q']." ORDER BY date DESC";
}else if($usrpos=='int'){
	$query="$sql[q] ORDER BY progress ASC, date DESC";
}else if($usrpos=='spv_eng'){
	$query=$sql['q'] . (($sql['qval']) ? (($sql['qval']['dept']&&$sql['qval']['dept']!=$dept) ? " AND (progress=2)" : " AND dept='{$dept}'") : " OR progress=2") . " ORDER BY date DESC, progress ASC";
}else if($usrpos=='spv_qa'){  //echo "<br>dept:$dept user-dept:$usrdept priv:"; print_r($_SESSION['user']['priviledges']);
	$query=$sql['q'];  //var_dump($sql['qval']['dept'] && preg_match('/'.$sql['qval']['dept'].'/', $_SESSION['user']['priviledges']));
	if($sql['qval']) $query .= (($sql['qval']['dept'] && (preg_match('/'.$sql['qval']['dept'].'/', $_SESSION['user']['priviledges']) || $sql['qval']['dept']=='all')) ? " OR (progress=3)" : " AND (progress=3)") . " ORDER BY date DESC, progress DESC";
	else $query .= " OR progress=3 ORDER BY date DESC, progress DESC";
}else if($usrpos=='spv_int'){
  $query="$sql[q] ORDER BY progress ASC, date DESC";
}//echo "<BR>===>".$query;

$db = getDb(); 
// $db->debug=true;
$rs=getQueryReport($db, $query, true);

if($rs['error']){
	$msg[]=$rs['error'];
}
else{
	if($rs['totalCount'] !=0){
		$data['pager']=$rs['pager'];
		$data['count']=$rs['totalCount'];
		$data['pages']=$rs['pageCount'];
		$data['report']=getBuildReport($db, $rs['rs']->getArray(), 'ls', "report_id,t1.position,submit_date,username,isReject");
		$rs['rs']->Close();	$rs=null;
	}
	else{
		$msg[] ='Report Empty';	
  }
}//echo "RESULT ==> <pre>"; print_r($data);  echo "</pre>";  var_dump(count($data['report'])); //die();

$smarty->registerPlugin("function","dept", "getDept");
$smarty->registerPlugin("function","activeUser", "activeUser");
$smarty->registerPlugin("function","unitLabel", "unitData");
$smarty->registerPlugin("function","status", "getStatus");	

if($_POST['print']){
	//usrlog("print list report ".getDept($dept),$db);
	$smarty->assign("q", array('dept'=>$dept, 'print'=>1),true);
	$smarty->assign("data", $data,true);
	$html=$smarty->fetch("report.tpl"); //echo "RESULT : $html"; die();
	$colsAtr=array('A'=>array('width'=>'12','align'=>'C'),'C'=>array('width'=>'AT'),'D'=>array('width'=>'AT'));
	$setting=array('label'=>"Report List $uname", 'headRows'=>3, 'colsAtr'=>$colsAtr,'colsize'=>12);
	printXls($html, $data['pages'] ." of ". $data['count']." Records", $setting);
}
else{
	$data['msg']=($msg) ? setMsg($msg, 'ui-state-error',null,null,'ui-icon-alert') : null;    //var_dump($sql['qval']['dept']);
	if($sql['qval']['dept']){ 
		if($sql['qval']['dept']=='all') $units = getUnits(true, null, true);
		else $units= getUnits(false, $sql['qval']['dept'], true);
	}else{
		$sql['qval']['dept']=($dept!='qa') ? $dept : null;
		$units=($dept!='qa') ? getUnits(false, $dept, true) : getUnits(true, null, true);
	}
	$selectDeptDis = (($usrpos!='admin'&&$dept!=$usrdept)||($usrpos=='int'||$usrpos=='spv_int')); 
	if($usrpos=='spv_qa') $selectDeptDis=false;
	$deptOpt = $usrpos==='admin' ? deptLabel() : getPriv(true, true);
	$deptSelected = ($sql['qval']['dept'] ? $sql['qval']['dept'] : $dept); 
	if(count(explode(',', $_SESSION['user']['priviledges'])) > 1) $deptSelected='';
	$q=array("dept"=>$dept,'selectDeptDis'=>$selectDeptDis,'pos'=>$usrpos, 'deptSelected'=>$deptSelected, 'depts'=>$deptOpt,'units'=>$units, 'page'=>$_POST['r_page']);
	// echo "<pre>"; print_r($q);	print_r($data); echo "</pre>"; die(0);
	 
	if(isset($sql['qval'])){
		$q=array_merge($q,$sql['qval']);
  }
	$smarty->assign("data", $data, true); 
	$smarty->assign("q", $q, true);
	$smarty->assign("page", array('title'=>"BMS-Report List $uname",'content'=>"report.tpl"), true);
	$smarty->assign("menu", array('list'=>$_SESSION['user']["menu"],'chid'=>($_SESSION['user']['position']=='admin') ? 'admin' : $_SESSION['user']['priviledges']));
	$smarty->display("layout.tpl");
} 
/*
SELECT report_id,t1.position,submit_date,username,isReject,t2.username,t2.fullname 
FROM comment as t1 join userlist as t2 on t1.uid=t2.id 
WHERE report_id in(2,3,40,1) and t2.username like 'eng%' and (t1.submit_date between '2016-04-21 00:00' and '2016-04-21 23:59')
order by submit_date asc   
*/
?>
