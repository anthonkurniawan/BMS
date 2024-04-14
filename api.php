<?php
include("verifyLogin.php");
include("function.php");

// $db=getDb();

function authLdap($username, $password){
  //echo "$username $password";
  $ldap = ldap_connect("192.168.56.3");
  $ldap_auth = ldap_bind($ldap, "w2003dns\\".$username, $password);
  return $ldap_auth;
  var_dump($ldap_auth); exit;
}

function login($username, $pass){
  $db=getDb();
  $db->SetFetchMode(ADODB_FETCH_ASSOC);
  $sql = "SELECT * FROM [userlist] WHERE username='$username'" ;
  $rs = $db->_Execute($sql);  //echo "<pre>";print_r($rs);echo"</pre>";exit;
  if(!$rs){
    $error = $db->ErrorMsg();
  }
  else{
    $user = $rs->fields;
    if(!$user){
      $error = "You do not have access to this system";
    }
    elseif ($user['status']==1){
      $error = "Username ".$username." is inactive";
    }
  }
  if($error) return array('error'=>$error);
  var_dump($error);

  $dbpass = md5($user['pass']);
  $md5_pass = md5($pass);
  if(LDAP_ENABLE){
    $ldap_auth = authLdap($username, $pass);
    if($ldap_auth){
      echo "<br>$pass<br>$dbpass<br>$md5_pass<br>";
      if($dbpass !== $md5_pass){
        echo "UPDATE PASS <br>";
        $rs = $db->_Execute("UPDATE userlist SET pass='{$md5_pass}' WHERE username='{$username}'");
      }
    }
  }else{
    $ldap_auth = true;
  }

  if(IGNORE_LDAP_FAIL){
    $ldap_auth = true;
  }


  $match = ($dbpass==$md5_pass);
  var_dump($match); //exit;
  if(!$ldap_auth || !$match) return array('error'=>'Incorrect username or password');
}

# NEW FOR SIGN LOGIN
if($_GET['q']=='login'){   //echo LDAP_ENABLE; exit;
  //print_r($_POST); die();
  $_POST['username'] = 'admin';
  $_POST['password'] = 'belang';
  if(!$_POST) return;
  $auth = login($_POST['username'], $_POST['password']);

  var_dump($auth); exit;
}

# NEW ADDING DB BACKUP ------------------------------------------------------------------
if($_GET['q']=='backup-exist'){
  $filename = $_GET['filename']; //'c:\BMS3-1.bak';
  echo "filename:$filename\n";
  var_dump(file_exists($filename));
  return;
}

// if($_GET['q']=='db-backup'){
	// $db = getDb();
	// // $db->debug=true;
  // $filename = $_POST['filename'];
  // $rs = $db->_Execute("backup database BMS to disk = '$filename' WITH FORMAT");
  // if($rs){
    // $rs = array('success'=>true);
    // //$db->CacheFlush("EXEC backupLog");
  // }else{
    // // $rs = array('error'=>'Can\'t backup database');
		// $rs=array('error'=>$db->ErrorMsg()); 
  // }
// }

if($_GET['q']=='db-backup'){
	// $cmd = 'sqlcmd.exe -U admin -P belang@9 -Q "EXEC bms3.dbo.SP_BACKUP @dir=\'c:\WEB\WWWROOT\BMS3\DB-BACKUP\'"';
	$cmd = 'sqlcmd.exe -U admin -P belang@9 -Q "EXEC bms3.dbo.SP_BACKUP"';
	// $cmd ='mkdir c:\XXX';
	// passthru($cmd, $rs);
	// exec($cmd, $out, $rs);
	$descriptorspec = array(
    0 => array('pipe', 'r'), // stdin
    1 => array('pipe', 'w'), // stdout
    2 => array('pipe', 'w'), // stderr
  );
  $process=proc_open($cmd, $descriptorspec, $pipes);
  // fwrite($pipes[0]);
  fclose($pipes[0]);

  // Read the outputs
  $out = stream_get_contents($pipes[1]);
  $err = stream_get_contents($pipes[2]); //var_dump($pdf); die();
  fclose($pipes[1]);
  $p = proc_close($process);

	// var_dump($out);
	// passthru($cmd, $rs);
	// exec($cmd, $out, $rs);
	// $escape_cmd = escapeshellcmd($cmd);  //echo $escape_cmd; die();
	// system($escape_cmd, $rs);
	$rs = strpos($out, 'successfully');
	// var_dump($err); var_dump($p); var_dump($rs); echo "<br>$out";
	
	// err: string(0) "" 
	// rs: int(0) 
	// out: string(220) "Processed 344 pages for database 'BMS3', file 'BMS3_Data' on file 4. Processed 1 pages for database 'BMS3', file 'BMS3_Log' on file 4. BACKUP DATABASE successfully processed 345 pages in 6.933 seconds (0.407 MB/sec). "
	// string(0) "" int(0) string(199) "Msg 3201, Level 16, State 1, Server WIN2003, Procedure sp_backup, Line 19 Cannot open backup device 'd:\WEB\WWWROOT\BMS3\DB-BACKUP\TEST-1.BAK'. Operating system error 21(The device is not ready.). "
	
	if($rs > 0){
		$rs = array('success'=>$out);
	}else{
		$rs = array('error'=>$out);
	}
}

if($_GET['q']=='switch-backup-job'){
	$name = 'BMS3-BACKUP-JOB';
	$db = getDb();
	$status = $db->GetOne("SELECT enabled FROM msdb.dbo.sysjobs WHERE name ='$name'"); //echo"<pre>";print_r($rs);echo"</pre>"; die();
	if($status!=NULL) {
		$status = $status ? 0 : 1;
		$rs = $db->_Execute("EXEC msdb.dbo.sp_update_job @job_name = '$name', @enabled = $status");
		if($rs){
			$rs = array('success'=>true);
		}else{
			$rs = array('error'=>$db->ErrorMsg());
		}
		// echo "<pre>"; print_r($rs);	echo "</pre>";
	} else $rs = array('error'=>$db->ErrorMsg());
}

// --------------------------------------------------------------------------------

# HISTORIAN DATA INTERVAL
# sc start IHDataArchiver
if($_GET['q']=='his-intv'){
  //print_r($_POST);
	$db = getDb();
	// $db->debug = true;
  $db->SetFetchMode(ADODB_FETCH_ASSOC);
  $rs=$db->getAll("
	select TOP 1 tagname, convert(datetime, timestamp) as time, value, quality FROM openquery(HISTORIAN,
'SELECT tagname, timestamp,value,quality FROM IHRAWDATA WHERE tagname=''XP-SP3.Simulation00001''')
order by timestamp DESC");
  if($rs){
    // print_r($rs);
    // $rs = $rs->fields;
  }else{
    // $rs = array('error'=>'Can\'t fecthing data');
		$rs = array('error'=>$db->ErrorMsg);
  }
}

if($_GET['q']=='his-trend'){
	$db = getDb();
	// $db->debug = true;
  $db->SetFetchMode(ADODB_FETCH_ASSOC);
	// max can fetch is 120 row
	// if starttime or timestamp conditional are not set the startime will begin at now - 120 row 
	// EXEC SP_GET_TRENDHIS @area_id=15, @intv='30m', @samplingmode='interpolated', @start_time='2023-07-30 15:00', @end_time='2023-07-30 16:00'
	$sql = "EXECUTE ('SELECT timestamp, *.value FROM ihTrend where timestamp >=now') at HISTORIAN";
	$sql = "EXEC SP_GET_TRENDHIS @area_id=15, @intv='30m', @samplingmode='interpolated', @start_time='2023-07-30 15:00', @end_time='2023-07-30 16:00'";
	$sql = "EXEC SP_GET_TRENDHIS @area_id=15, @start_time=NOW, @samplingmode='".$_GET['samplingmode']."'";
	$rs=$db->getAll($sql);
	
  if(!$rs){
		$err = $db->ErrorMsg;
		if(!$err) $err = 'Can\'t fecthing data';
		$rs = array('error'=>$err);
  }
	else $rs = $rs[0];
	// echo "<pre>"; print_r($rs); echo "</pre>"; die();
}

# ------------------------------------------------------------


if($_GET['q']=='timeline'){
	if($_SESSION['user']["position"]==='admin'){
			echo '{"isAdmin":true}'; exit;
	} 
  $usrdept=$_SESSION['user']["dept"];	  //echo"<pre>";print_r($_SESSION);echo"</pre>";die();
  $usrpos=$_SESSION['user']["position"];
  $privs=strpos($_SESSION["user"]["priviledges"],",");  //echo $_SESSION["user"]["priviledges"]; print_r($privs);

  if($usrpos=='admin'){
	  //$query="where progress=2 ORDER BY date DESC"; //2
	  $query="ORDER BY date DESC"; //2
  }else if($usrpos=='int'){
	  $query="where dept".(($privs)?" in({$_SESSION["user"]["priviledges"]})":"='$usrdept'")." AND progress=0 ORDER BY progress ASC, date DESC";  // 0     !!! BUAT TABLE DEPAREMENT AJA BUAT AMBIL LABEL
  }else if($usrpos=='spv' && ($usrdept!='eng'&&$usrdept!='qa')){
	  $query="where dept".(($privs)?" in({$_SESSION["user"]["priviledges"]})":"='$usrdept'")." AND progress=1 ORDER BY date DESC, progress ASC";
  }else if($usrpos=='spv' && $usrdept=='eng'){ 
	  $query="where progress=2 ORDER BY date DESC, progress ASC";
  }else if($usrpos=='spv' && $usrdept=='qa'){
	  $query="where progress=3 ORDER BY date DESC"; 
	}
  //$rs=$db->_execute($query);		//echo "<pre>"; print_r($db->getAssoc($query));	echo "</pre>"; die();
	$db = getDb();
	$rs=getQueryReport($db, $query, false, true);
  if(!$rs)
	  $rs=array('error'=>$db->ErrorMsg()); 
  else{									
	  $rs=$rs->getArray();		//echo "<pre>"; print_r($rs);	echo "</pre>";
	  if(count($rs) !=0){	
		  $rs=getBuildReport($db, $rs, 'api');
	  }else
		  $msg =setMsg('No Data');
  } 			
	// echo "<b>FINAL KREPORT :</b><pre>"; print_r($rs);	echo "</pre>";	die();
}
elseif($_GET['q']=='units'){
	$rs=($_GET['dept']!='all') ? getUnits(false, $_GET['dept'], true) : getUnits(false, false, true);
}
elseif($_GET['q']=='spv'){
	if(isset($_GET['dept'])){
		$query ="select id,username from userlist where status=2 and dept in(".$_GET['dept'].") and position='spv'"; //and priviledges like '%".$_GET['dept']."%'";
		$rs=$db->CacheExecute(3600*24, $query);
		if(!$rs) $rs= array('error'=>$db->ErrorMsg());
		else	$rs= $rs->GetAssoc();
	}
	else $rs = array('error'=>'priviledges not supply');
}
elseif($_GET['q']=='mailtest'){ //print_r($_POST['address']); die();
	$setting=getMailCfg($db); //echo"<pre>"; print_r($setting); echo "</pre>"; die(); #2592000 1month
	if(!$setting)
		$rs= array('error'=>"Error db email configuration :<br>".$db->ErrorMsg(),'debug'=>""); 
	else{
		$setting=array_merge($setting, $_POST['setting']); //echo "<pre>";print_r($setting); echo "</pre>"; die();
		require 'initMail.php';
		$rs=sendMail("BMS-TEST-MAIL", $_POST['message'], $_POST['address'], $setting); //echo "RESULT : ======================>"; var_dump($send);
	}
}
elseif($_GET['q']=='chart'){
	$db=getDb();
	$rs=$db->_Execute("SELECT count(tanggal) from TAGS_DATA");		//print_r($list);
	if(!$rs)
	  $rs= array('error'=>$db->ErrorMsg()); 
  else
    $rs=array('nilai'=>$rs->fields[0]);
}
elseif($_GET['q']=='flushdb'){ 
	$db=getDb();
	$db->debug=true;
	$db->CacheFlush();
}
elseif($_GET['q']=='cleantpl'){ //var_dump(dirname(__FILE__)); DIE();
	$tpl_c=glob('templates_c/*');
	$cache=glob('cache/*'); 
	$files=array_merge($tpl_c,$cache); echo "<pre>";print_r($files);echo"</pre>"; //die();
	$rs=array_map('unlink', $files);
}
elseif($_GET['q']=='insert-dummy'){
	// EXEC SP_INSERT_DUMMY @db='BMS', @table='tags_data'
	// EXEC SP_INSERT_DUMMY @db='BMS', @table='tags_data2022', @max=45, @start_time='2022-01-01 00:00'
	// sqlcmd -Q "EXEC SP_INSERT_DUMMY @db='BMS', @table='tags_data'" 
	 
	// $db=getDb();
	// $db->debug=true;
	// //$rs = $db->execute("EXEC SP_INSERT_DUMMY @db='bms', @table='tags_data', @max=45, @start_time='2022-01-01 00:00'");
	// $rs = $db->execute("EXEC SP_INSERT_DUMMY");
	$table = 'tags_data';
	$cmd = 'sqlcmd -U sa -P belang@9 -Q "EXEC bms.dbo.SP_INSERT_DUMMY @table=\''.$table.'\'"';
	$escape_cmd = escapeshellcmd($cmd);
	system($escape_cmd, $rs);
	// passthru('sqlcmd -Q "EXEC bms.dbo.SP_INSERT_DUMMY @table=\''.$table.'\'"', $rs);
	// exec('sqlcmd -Q "EXEC bms.dbo.SP_INSERT_DUMMY @table=\''.$table.'\'"', $out, $rs);
	if($rs==0){
		$rs = array('success'=>true);
	}else{
		$rs = array('error'=>'ERORRR..');
	}
}


//echo "<pre>"; print_r($rs);	echo "</pre>"; die();
echo json_encode($rs);

/*
---- FOR TESTING
DECLARE @area_id VARCHAR(3) = 0
DECLARE @start_time VARCHAR(30) = NULL
DECLARE @end_time VARCHAR(30) = NULL
DECLARE @intv VARCHAR(3) = '1m'
DECLARE @samplingMode VARCHAR(20) = 'Calculated'
DECLARE @newline VARCHAR(4) = char(13)+char(10)
DECLARE @sql VARCHAR(8000) --= 'SELECT timestamp, *.value FROM ihTrend where timestamp >= now'

IF(SELECT @intv) IS NOT NULL
		SET @sql = 'SET iintervalmilliseconds=' + @intv+ ','
IF(SELECT @samplingMode) IS NOT NULL
BEGIN
		IF(SELECT @sql) IS NOT NULL
				SET @sql = @sql + ' samplingMode='+ @samplingMode+','
		ELSE
				SET @sql = 'SET samplingMode='+ @samplingMode+','
END

--PRINT @sql
IF(SELECT @sql) IS NOT NULL
		SET @sql = @sql + @newline + 'SELECT timestamp'
ELSE
		SET @sql = @newline + 'SELECT timestamp'
		
IF(SELECT @start_time) IS NOT NULL
BEGIN
  IF(SELECT @end_time) IS NULL RETURN
  SET @start_time = (SELECT CONVERT(smalldatetime, @start_time))  --'Des 30 2021 12:00'
  SET @end_time = (SELECT CONVERT(smalldatetime, @end_time))      --'Des 30 2021 12:30'
END
ELSE
BEGIN
  SET @start_time = (SELECT GETDATE())
  SET @end_time = (DATEADD(minute, 1, @start_time))
END

SET @area_id = 0

PRINT 'area_id:"'+@area_id+'", start_time:"'+@start_time+'", end_time:"'+@end_time+'", intv:"'+ @intv+'", amplingMode:"'+ @samplingMode +'"'
PRINT NULL

IF(SELECT @area_id) <> 0
BEGIN
		DECLARE aCursor CURSOR STATIC FOR SELECT tagname.tagname, tagname.alias FROM tagname 
		LEFT JOIN units ON tagname.unitId = units.id WHERE units.id = @area_id
		DECLARE @tagname VARCHAR(200)
		DECLARE @tagname_alias VARCHAR(200)
		DECLARE @i VARCHAR(100) = 1;
		OPEN aCursor
		FETCH NEXT FROM aCursor INTO @tagname, @tagname_alias
		WHILE @@FETCH_STATUS = 0
		BEGIN
				print @tagname +' '+ @tagname_alias
				SET @sql = @sql + ',' + @tagname + '.value'
				SET @i = @i + 1;
				FETCH NEXT FROM aCursor INTO @tagname, @tagname_alias
		END
		CLOSE aCursor
		DEALLOCATE aCursor  --UNSET curso
END
ELSE
		SET @sql = @sql + ', *.value'
--  DECLARE aCursor CURSOR STATIC FOR SELECT tagname.tagname, tagname.alias FROM tagname

SET @sql = @sql + @newline + 'FROM ihTrend'
PRINT NULL
PRINT @sql


use BMS3
 --EXEC SP_GETHISTORIAN @area_id=15, @start_time='2023-07-27 00:00', @end_time='2023-07-27 12:00', @intv='30m', @samplingMode='Calculated'  

SELECT TOP 2 tagname, CONVERT(datetime, timestamp) AS time, CONVERT(decimal(10,2), value) AS value, quality 
FROM openquery(HISTORIAN, 
'SELECT tagname, timestamp,value,quality FROM IHRAWDATA WHERE tagname=XP-SP3.Simulation00001
OR tagname=SAMPLE.IFIX1_BATCH_REACTORLEVEL.B_CUALM AND timestamp >="2023-07-28 21:00"') 
order by timestamp DESC

----------------------------------------------------------------------
EXECUTE ('SET starttime="00:00", intervalmilliseconds=30m SELECT timestamp, *.value FROM ihTrend') AT HISTORIAN
*/
?>