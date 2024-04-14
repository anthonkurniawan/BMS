<?php
include("verifyLogin.php");
if($_SESSION['user']['position']!=='admin') header("location: ./noPrivilege.php");
 
require("lib/Smarty/libs/Smarty.class.php");
include("function.php");
$db=getDb();
$smarty=new Smarty; //$db->debug=true; //$smarty->debugging=true;
$smarty->caching=true;
$smarty->cache_lifetime=2592000;

function convert($bytes) {
	$symbols=array('B', 'KB', 'MB', 'GB', 'TiB', 'PB', 'EB', 'ZB', 'YB');
	$exp=$bytes ? floor(log($bytes)/log(1024)) : 0;
	return sprintf('%.2f '.$symbols[$exp], ($bytes/pow(1024, floor($exp))));
} 
	
#CHECK DISK DRIVE
$drive='c:';
$disk=disk_total_space($drive);
$free=disk_free_space($drive);
$used=$disk - $free ;
	
$disk_mb=round(($disk / 1048576),2);
$free_mb=round(($free / 1048576),2);
$used_mb=round(($used / 1048576),2);	
$total_disk=convert($disk);
$total_free=convert($free);	
	
$dbname = "BMS3";
$sql="SELECT DB_NAME(database_id) AS DatabaseName,Name AS Logical_Name,Physical_Name,size,(size*8)/1024 as SizeinMB,max_size FROM sys.master_files WHERE DB_NAME(database_id)='$dbname'";
$dbinfo=$db->CacheGetAll(86400, $sql);
																					
$free_P=$free_mb ? round($free_mb/$disk_mb, 2) * 100 : 0;
$used_P=round($used_mb/$disk_mb,2)*100 ;
$dbsize=$dbinfo[0][4]+$dbinfo[1][4]; //in MB
$dbsize_P=round($dbsize/$used_mb, 2) * 100;
$disk=array("disk"=>$disk,"free"=>$free,"used"=>$used,"dbsize"=>$dbsize,"disk_mb"=>$disk_mb,"free_mb"=>$free_mb,"used_mb"=>$used_mb,"total_disk"=>$total_disk,"total_free"=>$total_free,"free_P"=>$free_P,"used_P"=>$used_P,"dbsize_P"=>$dbsize_P);
	
#HISTORIAN JOB AGENT
 $rs=$db->CacheGetAll(120, "EXEC jobLog");
//$rs=$db->GetAll(1800, "EXEC dbo.jobLog");
$jobLog=($rs)?$rs :null; 
//echo"<pre>";print_r($jobLog);echo"</pre>";die();

$data=array('dbinfo'=>$dbinfo,'jobLog'=>$jobLog,'disk'=>$disk);
// echo "<pre>"; print_r( $data);	echo "</pre>"; die(0);

$smarty->assign("data", $data,true );
$smarty->assign("menu", array('list'=>$_SESSION['user']["menu"],'chid'=>($_SESSION['user']['position']=='admin') ? 'admin' : $_SESSION['user']['priviledges']));
$smarty->assign("page", array('title'=>'BMS-DB Monitor','content'=>"db_monitor.tpl"), true);
$smarty->display("layout.tpl");  
//usrlog("Access db-monitor",$db);
?>
