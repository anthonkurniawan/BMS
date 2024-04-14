<?php
include("verifyLogin.php");
if($_SESSION['user']['position']!=='admin') header("location: ./noPrivilege.php");
 
require("lib/Smarty/libs/Smarty.class.php");
include("function.php");
$db=getDb();
$smarty=new Smarty; //$db->debug=true; //$smarty->debugging=true;
$smarty->caching=true;
$smarty->cache_lifetime=2592000;

$backupUrl = "http://aspja2w003/BMS3/DB-BACKUP/";
$backupUrl = "http://192.168.56.2:8080/BMS3/DB-BACKUP/";
$backupUrl = "http://192.168.56.3/BMS3/DB-BACKUP/";
$backupDir = "C:\\WEB\\BMS3\\DB-BACKUP";
$backupTarget = "C:\\\\WEB\\\\BMS3\\\\DB-BACKUP\\\\";
$backupDir = "D:\\APP\\PHP\\BMS3\\DB-BACKUP";
$backupTarget = "D:\\\\APP\\\\PHP\\\\BMS3\\\\DB-BACKUP\\\\";
$dbname = "BMS";
$sql="SELECT Name AS Logical_Name,Physical_Name FROM sys.master_files WHERE DB_NAME(database_id)='$dbname'";
$dbinfo=$db->CacheGetAll(86400, $sql);
								
$sql="SELECT TOP 1 JOB.name, JOB.enabled,
convert(smalldatetime,JOB.date_created), convert(smalldatetime, msdb.dbo.agent_datetime(run_date, run_time)) as'RunDateTime'
--JOB.date_created
FROM  msdb.dbo.sysjobs JOB
LEFT JOIN  msdb.dbo.sysjobhistory HIST ON HIST.job_id=JOB.job_id
WHERE JOB.name='BMS3-BACKUP-JOB'";
$jobInfo=$db->getAll($sql);
// echo "==><pre>"; print_r($jobInfo);	echo "</pre>";
// echo $db->ErrorMsg(); exit(0);

$sql="SELECT name, create_date, recovery_model_desc FROM sys.databases where name='$dbname'";
$dbinfo2=$db->getAll($sql);
if($dbinfo2)
	$backupTarget = $backupTarget . $dbname . "-" . $dbinfo2[0][2] . ".BAK";
else 
	$backupTarget = $backupTarget . $dbname . ".BAK";

#HISTORIAN JOB AGENT
// $rs=$db->CacheGetAll(3600, "EXEC backupLog");
$rs=$db->getAll("EXEC backupLog");

if($rs) {
	foreach ($rs as $k=>$v){
		// echo "$k => " . strtolower($v[4]) . " ";
		// var_dump(preg_match('C:\\DB-BACKUP\\', $v[4]));
		if(strpos($v[4], $backupDir) !== false) {
			// echo "TRUE " . strpos($v[4], $backupDir);
			// echo " " . substr($v[4], strlen($backupDir)+1);
			// $v[4] = "BOLL";
			$rs[$k][] = $backupUrl . substr($v[4], strlen($backupDir));
		}
	}
}
$backupLog = ($rs) ? $rs : null;
// echo "<pre>"; print_r( $backupLog);	echo "</pre>"; exit(0);

function getLinkDbBackup($p) {  // NOT-USED
	if(strpos($p['file'], $p['backupDir']) !== false) {
		return substr($p['file'], strlen($p['backupDir'])+1);
	}
}

// $backupLog = NULL;
$data=array('backupTarget'=>$backupTarget, 'backupTargetLabel'=> str_replace("\\\\","\\",$backupTarget), 'jobInfo'=>$jobInfo, 'dbinfo'=>$dbinfo, 'dbinfo2'=>$dbinfo2, 'backupLog'=>$backupLog);
// echo "<pre>"; print_r( $data);	echo "</pre>"; die(0);

$smarty->registerPlugin("function","link", "getLinkDbBackup");
$smarty->assign("data", $data, true );
$smarty->assign("menu", array('list'=>$_SESSION['user']["menu"],'chid'=>($_SESSION['user']['position']=='admin') ? 'admin' : $_SESSION['user']['priviledges']));
$smarty->assign("page", array('title'=>'BMS-DB BACKUP','content'=>"backup.tpl"), true);
$smarty->display("layout.tpl");  
//usrlog("Access db-monitor",$db);
?>
