<?php
error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING & ~E_DEPRECATED);
define('LDAP_ENABLE', true);
define('IGNORE_LDAP_FAIL', false);
include_once("lib/adodb5/adodb.inc.php");
include_once("db.php");

function getDb(){
	return Db::connect();
}

// function, api, login, user, users, userlog, report, reporting, tagexport, done, about, emailUtil, noPriviledge, tagtime
function setMsg($msgs, $type = 'ui-state-highlight', $btn = false, $style = null, $icon = "ui-icon-info") {  //print_r($msgs); die(); 
  if (is_array($msgs)) {
    if (count($msgs) > 1) {
      foreach ($msgs as $m)
        $msg .= "<span class='ui-icon $icon'></span> $m <br>";
    } else
      $msg = "<span class='ui-icon $icon'></span> $msgs[0]";
  } else
    $msg = "<span class='ui-icon $icon'></span> $msgs";
  $btn = ($btn) ? "<p><a href='$btn'class='btn btn-primary'> <i class='newReport'></i> Lanjut</a></p>" : "";
  return "<div class='$type report_msg ui-corner-all ui-helper-clearfix' style='display:block;$style'><div class='msg'>$msg $btn</div><a href='#' class='msgClose right ui-icon ui-icon-close'></a></div>";
}

function getMsg() {  // index, user, users 
  if ($_SESSION['user'] && $_SESSION['user']['msg']) { //echo "<pre>";print_r($_SESSION['user']['msg']);echo"</pre>";//die();
    $data = setMsg($_SESSION['user']['msg'], 'ui-state-highlight', null, 'margin-top:5px', 'ui-icon-info');
    $_SESSION['user']['msg'] = null;
    return $data;
  }
  return;
}

function buildQuery($post, $keys, $query='') { 
  $post = preg_replace("/[';]/", "", $post); //echo "<pre>";print_r($post);echo"</pre>";//die();
  $cond = array('id' => '=', 'username' => 'like', 'fullname' => 'like', 'email' => 'like', 'dept' => '=', 'unit' => '=', 'position' => '=', 'priviledges' => 'like', 'status' => '=', 'date' => 'like', 'event' => 'like');
  foreach ($keys as $i => $k) {  //echo "=>$i, $k<br>"; 
    if ($post[$i]) {
      $qval[$i] = ($i == 'dt' || $i == 'ds' || $i == 'de') ? date('Y-m-d', strtotime($post[$i])) : $post[$i];
      if ($i == 'dt') {
        $query .= (($query) ? " AND " : " WHERE ") . " date BETWEEN '$qval[$i] 00:00' AND '$qval[$i] 23:59:59'";
      } elseif ($i == 'ds' || $i == 'de') {
        $query .= (($query) ? " AND " : " WHERE ") . (($i == 'ds') ? "date BETWEEN '$qval[$i] 00:00'": " '$qval[$i] 23:59:59'");
      } elseif ($i == 'dept' && $qval[$i]=='all') {
				continue;
      }elseif($i=='priv'){
				$query .= (($query) ? " AND " : " WHERE ") . " $k like '%$qval[$i]%'";
			}else {
        $query .= (($query) ? " AND " : " WHERE ") . (($cond[$k] == 'like') ? " $k like '$qval[$i]%'" : " $k='$qval[$i]'");
      }
    }
  }
  return array('q' => $query, 'qval' => $qval);
}


function validateInput($data = array(), $validate = array()) {
  $data = preg_replace("/[';]/", "", $data);
  foreach ($data as $i => $v) {  //echo "<BR>$i=>$v";
    if (in_array($i, $validate)) { //echo "<BR>ada : $i";
      if (!$v) $error[] = ucfirst($i) . " is required";
    }
  }
  if ($error) $data['error'] = $error; //echo"<br>DATA : <pre>";print_r($data);echo"</pre>"; die();
  return $data;
}

# users, userlog, report, reporting, tagexport
function printXls($html, $ket, $setting) { //echo"<pre>";print_r($_SERVER['PHP_SELF']);echo"</pre>"; var_dump(preg_match("/report.php/",$_SERVER['PHP_SELF'])); die();
  $tmpfile = "tmp/" . time() . '.html'; //echo "tmp file : $tmpfile"; die();
  file_put_contents($tmpfile, $html);

  require_once 'lib/PHPExcel-1.8/Classes/PHPExcel.php';
  $objPHPExcel = new PHPExcel();
  $excelHTMLReader = PHPExcel_IOFactory::createReader('HTML');
  $excelHTMLReader->loadIntoExisting($tmpfile, $objPHPExcel);
  $rows = $objPHPExcel->getActiveSheet()->getHighestRow(); // find max row
  $cols = $objPHPExcel->getActiveSheet()->getHighestColumn(); // find max col 
  $colsIdx = PHPExcel_Cell::columnIndexFromString($cols);  //echo "rows: $rows cols:$cols col-index: $colsIdx"; die(); # 4 G 7

  $area = "A2:" . $cols . $rows;
  $headerArea = "A2:" . $cols . $setting['headRows'];
  $bodyStart = $setting['headRows'] + 1;
  $bodyArea = "A" . $bodyStart . ":" . $cols . $rows;
  $pages = $cols . "1";
  $colsize = ($setting['colsize']) ? $setting['colsize'] : 15; //echo "rows: $rows cols:$cols col-index:$colsIdx<br>area:$area, headerArea:$headerArea, bodystart:$bodyStart, bodyArea:$bodyArea, pages:$pages, colsize:$colsize PATH:$_SERVER[PHP_SELF]"; die();
  $objPHPExcel->getActiveSheet()->setCellValue($pages, $ket)->getStyle($pages)->getAlignment()->setHorizontal((($ket == 'error') ? PHPExcel_Style_Alignment::HORIZONTAL_LEFT : PHPExcel_Style_Alignment::HORIZONTAL_RIGHT));
  $objPHPExcel->getActiveSheet()->setCellValue($pages, $ket)->getStyle($pages)->getFont()->setBold(true);
  $objPHPExcel->getActiveSheet()->getStyle($pages)->getFont()->setSize(9);
  $objPHPExcel->getActiveSheet()->getDefaultStyle()->getFont()->setSize(10);
  $objPHPExcel->getActiveSheet()->getDefaultColumnDimension()->setWidth($colsize); // set default width col - 10 for report
  $objPHPExcel->getActiveSheet()->setTitle( substr($setting['label'], 0,31) );
	//$objPHPExcel->getActiveSheet()->setTitle($setting['label']);
  # FORMAT ALL AREA
  $areastyl = array(
      'borders' => array('allborders' => array('style' => PHPExcel_Style_Border::BORDER_THIN)),
  );
  # FORMAT HEADER
  $headerstyl = array(
      'font' => array('size' => 10, 'bold' => true,),
      'alignment' => array('horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER, 'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,),
      'fill' => array(
          'type' => PHPExcel_Style_Fill::FILL_GRADIENT_LINEAR,
          'rotation' => 90,
          'startcolor' => array('argb' => 'bde1f5;'),
          'endcolor' => array('argb' => 'FFFFFFFF'),
      ),
  );
  $objPHPExcel->getActiveSheet()->getStyle($area)->applyFromArray($areastyl);
  $objPHPExcel->getActiveSheet()->getStyle($headerArea)->applyFromArray($headerstyl);
  if (isset($setting['colsAtr'])) {
    foreach ($setting['colsAtr'] as $i => $atr) {  //echo "<br>"; print_r($i); print_r($atr);
      if ($atr['width'] == 'AT') { //echo $i . $atr['width'];
        $objPHPExcel->getActiveSheet()->getColumnDimension($i)->setAutoSize(true);
      } elseif ($atr['width'])
        $objPHPExcel->getActiveSheet()->getColumnDimension($i)->setWidth($atr['width']);
      if (isset($atr['align'])) { //echo $i . $atr['align']; die();
        $objPHPExcel->getActiveSheet()->getStyle($i . $bodyStart . ":" . $i . $rows)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
      }
    }
  }
  if (preg_match("/report.php/", $_SERVER['PHP_SELF']))
    $objPHPExcel->getActiveSheet()->getStyle("E$bodyStart:" . $cols . $rows)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);

  unlink($tmpfile);
  header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'); // header for .xlxs file
  header('Content-Disposition: attachment;filename="' . trim($setting['label']) . '.xlsx"'); // specify the download file name
	//header('Content-Disposition: attachment;filename="xxx.xlsx"'); 
  header('Cache-Control: max-age=0');
  $writer = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
  ob_end_clean();
  $writer->save('php://output');
  exit;
}

# email, emailUtil, api
function getMailCfg($db) {
  $db->SetFetchMode(ADODB_FETCH_ASSOC);
  $rs = $db->CacheGetRow(2592000, 'select * from emailcfg where id=2'); //echo"<pre>"; print_r($rs); echo "</pre>"; die(); #2592000 1month
  if(!$rs){
		$_SESSION['mailcfg']['error'] = "Error db email configuration :<br>".$db->ErrorMsg();
	}else{
		$_SESSION['mailcfg'] = $rs;
		return $rs;
	}
	//echo"<pre>"; print_r($_SESSION['mailcfg']); echo "</pre>";
}

# COMMON FN -----------------------------------------------------------------------------------------------------------------------------------------------------
# function, index 
function getPriv($label=false, $withKey=false) {
  $privs = str_replace('"', '', $_SESSION["user"]["priviledges"]);   //echo "===>".$priv;
  if (preg_match('/,/', $privs)) {
    $priv = explode(',', $privs);
    if ($label) {
      foreach ($priv as $p){
				if($withKey) $arr[$p] = deptLabel($p);
        else $arr[] = deptLabel($p);
			}
      $priv = $arr;
    }
  }
	else $priv = ($label) ? deptLabel($privs) : $privs;
  return $priv;
}

//function getPrivDepts(){ // GA DI PAKE
	//$q = "WHERE";
	//foreach (explode(',', str_replace('"', '', $_SESSION["user"]["priviledges"])) as $k=>$v) $q.= $k > 0? " OR dept='".$v."'" : " dept='".$v."'";
	//return $q;
//}

# reporting, report
function accesspriv($dept) {
  $priv = getPriv();  //echo"<br> getPriv dept: $dept -> ";print_r($priv);//die();
  if (is_array($priv)) {
    foreach ($priv as $p) {
      if ($p === $dept) return true;
    }
  }
  else {
    return ($dept === $priv);
  }
}

# function, users, userlog, report 
function deptLabel($key='') {
  foreach ($_SESSION['units'] as $k => $v) { //echo "k=>$k, v=>$v";
    if ($key) {
      if ($key == $k)
        return $v['label'];
    } else
      $dept[$k] = $v['label'];
  }       //	echo"DEPTS: <pre>";print_r($dept);echo"</pre>";
  return $dept;
}

# users, userlog, report
function getDept($key) {  //echo "get-dept:$key"; // CARI DEPT CODE SAAT CREATE NEW REPORT
  $key = (is_array($key)) ? $key['d'] : $key;
  foreach ($_SESSION['units'] as $k => $v) {
    if ($key == $k) $dept = $v['label'];
  }
  return ($dept) ? $dept : 'All';
}

#for menu - tagexport, api, login, report
function getUnits($priv=false, $dept='', $ls=false) { // echo "get-unit: $priv, $dept, $ls";
  $units = $_SESSION['units'];
  if ($priv) {
    $priv = getPriv();  //print_r($priv);
    if (is_array($priv)) {
      foreach ($priv as $v) {
        $unit_u[$v] = $units[$v];
      }
    } else
      $unit_u[$priv] = $units[$priv];
    $units = $unit_u;
    $unit_u = null;
  }
  elseif ($dept && $dept!='all') {
    $units = $units[$dept];
  }
  if ($ls) {
    if ($dept)
      return $units['units'];
    foreach ($units as $v) {
      $unit_u[$v['label']] = $v['units'];
    }
    return $unit_u;
  }
  return $units;
}

# login
function unitStore($db) {
  return deptData($db);
}

function deptData($db, $dept='') {
  $db->SetFetchMode(ADODB_FETCH_NUM);
  $db->CacheFlush('select t2.code as dept, t2.label as dept_lbl, t1.code as unit, t1.label as unit_lbl from units as t1 join depts as t2 on t1.deptId=t2.id');
  $arr = $db->CacheGetAll(1000, 'select t2.code as dept, t2.label as dept_lbl, t1.code as unit, t1.label as unit_lbl from units as t1 join depts as t2 on t1.deptId=t2.id'); //echo"ARR: <pre>";print_r($arr);echo"</pre>"; die();
  foreach ($arr as $v) {
    if ($v[2])
      $depts[$v[0]]['units'][$v[2]] = $v[3];
    else
      $depts[$v[0]]['units'] = array();
    $depts[$v[0]]['label'] = $v[1];
  }                   // echo"DEPTS: <pre>";print_r($depts);echo"</pre>"; die();
  return ($dept) ? $depts[$dept] : $depts;
}

function unitData($u) {
  if (is_array($u)) {
    $key = $u['key'];
    $u = $u['u'];
  }
  foreach ($_SESSION['units'] as $k => $v) {  //echo "<br>$u : $k ";print_r($v['units']);
    if ($v['units'][$u]) {
      $unit['dept'] = $k;
      $unit['unit_lbl'] = $v['units'][$u];
      $unit['dept_lbl'] = $v['label'];
      return ($key) ? $unit[$key] : $unit;
    }
  }
}

function getPager($db, $q, $rows = 10, $print = false) {
	$db->SetFetchMode(ADODB_FETCH_ASSOC);
  include_once('pager.php');
  $pager = new ADODB_Pager($db, $q, "r", true);
  return $pager->myRender($rows, $print);  //echo "PAGER : <pre>";print_r($rs);echo"</pre>"; die();//echo $rs->ErrorMsg(); die();
}

function usrlog($events, $db=null) { //echo"USERLOG : <pre>";print_r($events);echo"</pre>"; 
	if(!isset($_SESSION['user']["authenticated"])) header( "Location: ./login.php" ); 
	if(!$db) $db = getDb();
  if (is_array($events)) {
    foreach ($events as $e)
      $db->_query("insert into userlog (date,userid,event) values (".$db->sysTimeStamp.",'{$_SESSION['user']['id']}', '$e')");
  } else
    $db->_query("insert into userlog (date,userid,event) values (".$db->sysTimeStamp.",'{$_SESSION['user']['id']}', '$events')");
}

# DAILY REPORT PRINT & ENG.PHP, .. ---------------------------------------------------------
function tab3($deptR) { //echo $deptR;
  return ($deptR == 'eng' || $deptR == 'qa');
}

function timeList($date, $time) {
  $interval = 86400 / $time;  //86400 = 24hour
  $csr = 0;
  for ($i = 1; $i <= $interval; $i++) {
    $clock = num_to_time($csr);
    $csr = $csr + $time;
    $dt = $date . " " . $clock;
    if (date("Y-m-d H:i", strtotime($dt)) > date("Y-m-d H:i"))
      break;
    $ls_time .= "'" . $date . " " . $clock . "' ,";
  }
  return substr($ls_time, 0, -1);
}

function num_to_time($num) {
  $hours = floor($num / 3600);
  $minutes = floor(($num - ($hours * 3600)) / 60);
  $seconds = $num - (($hours * 3600) + ($minutes * 60));
  $time = $hours . ':' . $minutes . ':' . $seconds;
  return $time;
}

function getTable($date) {
  $y = date("Y", strtotime($date));
  return (date("Y") === $y) ? 'TAGS_DATA' : "TAGS_DATA" . $y;
}

function statusAct($act) {
  return ($act) ? "Reject" : (($_SESSION['user']['position'] == 'int') ? "Update" : "Approve");
}

function getStatus($p) {  #using email.php, report.tpl //echo $p;print_r($p);
  $v = (is_array($p)) ? $p['stat'] : $p;
  return ($v == '1') ? 'No deviasi' : '<font color="#FF0000">Deviasi</font>';
}

#--------------------------------------------  CREATE / UPDATE REPORT -----------------------------------------------------
function report($db, $priv, $progress, $dept_label, $unit, $dept, $unit_label) {  //$db->debug=true;  echo "<pre>";print_r($_SESSION);ECHO"</PRE>";
  //echo "<br>progress:$progress dept:$dept, dept_label:$dept_label unit:$unit code_unit:$dept unit label:$unit_label <pre>";	print_r($_POST);echo"</pre>";		//die();
  if ($_SESSION['user']['dept'] !== $dept) {
    $validate = getReport($db, $priv, null, $unit, $dept, 'validate');   //echo "getReport validate:<pre>";print_r($validate);echo"</pre>";
    //echo "<br> POST VALIDATE REPORT: <pre>";print_r($validate);//echo "</pre>"; //die(); //return array('error'=>$info); XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    if ($validate['error']) {
      header("location: ./noPrivilege.php");
      exit;
    }
  }
  $curr_time = date('Y-m-d H:i');
  $pos = getPosCode();
  $date = date('Y-m-d', strtotime($_POST["date"]));
  $status = $_POST['status'];
  $comment = $_POST['comment'];

  if (!$_POST['id']) {
    $rs = $db->GetOne("select count(*) from report where date='$date' and unit='$unit'"); 
    if ($rs > 0)
      return array('error' => 1, 'info' => 'You can\'t create report has allready exist!');

    $act = "Create";
    $id = getLastPk($db, 'report');
		// echo"<pre>";print_r($id);echo"</pre>"; die();
    $info = $act . " new report $unit_label $date"; 
		$db->debug = true;
    $rs = $db->_execute("Set IDENTITY_INSERT report ON INSERT INTO report(id,unit,dept,date,status,progress) VALUES('{$id}','{$unit}','{$dept}','{$date}','{$status}','{$progress}') Set IDENTITY_INSERT report OFF"); //echo"<pre>";var_dump($rs);echo "</pre>";die();
    # MYSQL !
    //$rs = $db->_execute("INSERT INTO report(id,unit,dept,date,status,progress) VALUES('{$id}','{$unit}','{$dept}','{$date}','{$status}','{$progress}')"); //echo"<pre>";var_dump($rs);echo "</pre>";die();
    if ($rs) {   //echo "xxx";die();
      $rs = $db->_execute("INSERT INTO comment (report_id, submit_date, comment, position, uid) VALUES ('{$id}','{$curr_time}', '{$comment}','{$pos}','{$_SESSION['user']["id"]}')");
      if (!$rs) {
        $err = htmlentities($db->ErrorMsg(), ENT_QUOTES);
        $db->_Execute("DELETE FROM report WHERE id=$id");
      }
    } else{
      $err = htmlentities($db->ErrorMsg(), ENT_QUOTES);
		}
  }
  else {
		$id = $_POST['id'];
		$rs = $db->GetOne("select progress from report where id=$id"); //var_dump($rs); //echo"<pre>";print_r($rs);echo"</pre>"; //die();
		if(!progressValidate($rs)){   
			$_SESSION['user']['msg'] ="Report id:$id $unit_label $date Already submited"; 
			return; 
		}
		
    $act = statusAct($_POST['isReject']);
    $db->StartTrans();
    $rs = $db->_Execute("UPDATE report SET progress='{$progress}', status='{$status}', update_date='{$curr_time}' WHERE id='{$id}'");  // [_errormsg] [_errorno]
    $db->_Execute("INSERT INTO comment (report_id,submit_date,comment,position,uid,isReject) VALUES ('{$id}','{$curr_time}', '{$comment}','{$pos}','{$_SESSION['user']["id"]}','{$_POST["isReject"]}')");
    $rs = $db->CompleteTrans();
    if (!$rs)
      $err = htmlentities($db->ErrorMsg(), ENT_QUOTES);
  } //$rs=1; // BUAT TEST
  $info = ($rs) ? "$act report id:$id $unit_label $date Success" : "Error: $act report id:$id $unit_label $date " . (($err) ? "<br>- $err" : "");
  if (!$rs)
    return array('error' => 1, 'info' => $info);
  
  if($rs){		// && ($progress < 4 || !$_POST['id']) 
    require("email.php");       //echo "EMAIL-RS: <pre>"; print_r($mail); echo"</pre>";
    if($progress==4) $info .=' & Complete';
    $mail = ($mail['error']) ? ($info . " <br>" . $mail['error']) : $info . " <br>" . $mail['success'];   
  } 		//var_dump($progress < 4); var_dump($id); var_dump((($progress < 4 || !$id) && $rs));
  $_SESSION['user']['msg'] = $mail;
  return array('error' => 0, 'info' => $mail);
}

function progressValidate($progress){  //echo "<pre>";print_r($_SESSION['user']);echo"</pre>";
	$pos = getPosCode();
	if($progress==0 && $pos==='int') return true;
	elseif($progress==1 && $pos==='spv_int') return true;
	elseif($progress==2 && $pos==='spv_eng') return true;
	elseif($progress==3 && $pos==='spv_qa') return true;
	return false;
}

function getPosCode() {
  //echo "<pre>";print_r($_SESSION['user']);echo"</pre>"; die();
  $user = $_SESSION['user'];
  if ($user['position'] == 'admin') return 'admin';
  elseif ($user['position'] == 'int') return 'int';
  elseif ($user['position'] == 'spv'){
		if ($user["dept"] == 'eng') return "spv_eng";
		elseif(preg_match('/qo|qa/',$user["dept"]) && preg_match('/qa/',$user['priviledges'])) return "spv_qa";
		else return "spv_int";
	}
}
function getPosCode2() {
  if ($_SESSION['user']['position'] == 'admin')
    return 'admin';
  elseif ($_SESSION['user']['position'] == 'int')
    return 'int';
  elseif ($_SESSION['user']["dept"] == 'eng' || $_SESSION['user']["dept"] == 'qa')
    return $_SESSION['user']['position'] . "_" . $_SESSION['user']["dept"];
  //elseif($_SESSION['user']["dept"] == 'qo' && $_SESSION['user']['position']=='spv'){ 	XXXXXXXXXXXXXXXXXXXXXX
  
  //}
  else return $_SESSION['user']['position'] . "_int";
}

function getPosLabel($c) {
  switch ($c) {
    case 'int':return "Initiator";
      break;
    case 'spv_int':return "Initiator Spv";
      break;
    case 'spv_eng':return "Engineering Spv";
      break;
    case 'spv_qa':return "Quality Assurance Spv";
      break;
  }
}

function getLastPk($db, $t) {
  $db->SetFetchMode(ADODB_FETCH_NUM);
  $rs = $db->_Execute("select max(id)+1 from $t")->fields[0];
  return ($rs) ? $rs : 1;
}

#--------------------------------------------  GET EXISTING REPORT -----------------------------------------
function getActiveTab($tab3) {
  if ($_SESSION['user']['position'] == 'admin')
    return array('active' => 0, 'disabled' => 1);
  elseif ($_SESSION['user']['position'] == 'int')
    return array('active' => 0, 'disabled' => ($tab3) ? '[1,2]' : '[1,2,3]');
  elseif ($_SESSION['user']['position'] == 'spv' && $_SESSION['user']["dept"] == 'eng')
    return array('active' => ($tab3) ? 1 : 2, 'disabled' => ($tab3) ? '[0,2]' : '[0,1,3]');
  elseif ($_SESSION['user']['position'] == 'spv' && $_SESSION['user']["dept"] == 'qa')
    return array('active' => ($tab3) ? 2 : 3, 'disabled' => ($tab3) ? '[0,1]' : '[0,1,2]');
  else
    return array('active' => 1, 'disabled' => '[0,2,3]');
}

function validateDate($date, $unit=null) {
  $date = date('Y-m-d', strtotime($date));
  $minDate = date('Y-m-d', strtotime('04/25/2017'));
  $wfi_maxDate = date('Y-m-d', strtotime("2022-12-20"));
// echo "date:$date max_date:$wfi_maxDate";
  //echo "<br>VALIDATE DATE : ".$_GET["date"]." res: $date ";  //die();
  if ($date == '1970-01-01')
    return array("error" => "Invalid Date");
  if ($date > date('Y-m-d'))
    return array("error" => "Date is in the future");
  if ($unit=='wfi' && $date > $wfi_maxDate)
    return array("error" => "Data only available before 21 december 2022");
	if ($date < $minDate)
    return array("error" => "Data not available. (only available on BMS2)");
  return $date;
}

function reportValidate($report, $priv) {      //echo "<BR><B>REPORT VALIDATE..</B><pre>"; print_r($report);  echo "</pre>".$_SESSION['user']['position'];
  if (isset($_GET['id']) && !$report) {
    return array('error' => 'Report not found');
  }
  elseif ($report && $report[0]['unit'] !== $_GET['unit']) {
    return array('error' => 'Invalid Request !');
  } elseif ($report && $report[0]['dept'] !== $_SESSION['user']['dept'] || $_POST) {
    if ($priv) {
      return true;
    } elseif ($_SESSION['user']["dept"] == 'eng' && $_SESSION['user']['position'] == 'spv' && $report[0]['progress'] == 2) {
      return true;
    } elseif ($_SESSION['user']["dept"] == 'qa' && $_SESSION['user']['position'] == 'spv' && $report[0]['progress'] == 3) {
      return true;
    } else {
      return array('error' => 'You dont have priviledge for this request');
    }
  }
  return true;
}

//$ADODB_FETCH_MODE=ADODB_FETCH_ASSOC;
function getReport($priv, $id, $unit, $dept, $mode = false) {
  //echo "getReport: id:'$id', unit:'$unit', dept:'$dept', priv:'$priv', date:'$date', print:'$mode'<br>"; //die();
  if ($id) {
    $query = " WHERE id=$id";
  } else {
    if (isset($_GET['id'])) {  //echo "validate id"; var_dump((int)$_GET['id']);die();
      if (!(int) $_GET['id'])
        return array('error' => 'Invalid report id');
      $query = " WHERE id=$_GET[id]";
    }
    elseif ($_GET['date']) {
      //echo "=>".$priv; die();
      $date = validateDate($_GET['date'], $unit);
      if (is_array($date)) {
        return array('error' => $date['error']);
      }
      $query = " WHERE unit='$unit' AND date='$date'";
    }
  }
	
  #GET REPORT
	$db = getDb();
  $rs = getQueryReport($db, $query);
  if (!$rs)
    return array('error' => "<b>Failed getting report:</b>" . $db->ErrorMsg());
  else
    $report = $rs->getArray();
  //echo "<BR><B>EXISTING REPORT : </B><pre>";print_r($report);  echo "</pre>";//die();
  
	# VALIDASI BY DEPT & PROGRESS -----------------------------
  $validate = reportValidate($report, $priv);                       // echo "<br><B>VALIDATE ACCESS REPORT : </B>"; var_dump($validate);
  if ($validate !== true || $mode == 'validate')
    return $validate;

  # GET TAGS DATA --------------------------------
  $date = ($report[0]) ? $report[0]['date'] : $date;
  //echo "<br><b>date: $date - report[0][date]: ".$report[0]['date']."</b>"; //die();
  if (!$date)
    return array('error' => 'Invalid report');

  $tdata = getTagsData($unit, $date, $db, $report[0]);        //echo "<BR><B>TAGS DATA : </B> count ". count($tdata); print_r($tdata); //die();
  if (isset($tdata['ferror']))
    return array('error' => $tdata['ferror']);

  $report['tdata'] = $tdata;

  # BUILD REPORT
  if (!$report[0]) {
    $report[0] = array("id" => false, "date" => $date, "dept" => $dept, "unit" => $unit, "status" => null, "progress" => 0);
  }
  if ($report['tdata']['error'])
    return $report;
  if ($mode == 'xls')
    return $report;
  $db->SetFetchMode(ADODB_FETCH_ASSOC);
  $report[0] = getBuildReport($db, array($report[0]), $mode);
  return $report;
}

function getTagsData($unit, $date, $db, $report) {
  $db->SetFetchMode(ADODB_FETCH_NUM);
  //$rtime = $db->CacheGetOne(3600 * 24, "SELECT time FROM tagtime");  //var_dump($rtime); die();
  //if (!$rtime) {
    //$msg = $db->ErrorMsg();
    //return array('ferror' => "<b>Failed get setting interval tagtime:</b><br>" . (($msg) ? $msg : 'Setting interval time is empty'));
  //}
  $rtime = 1800;
  if ($date != date('Y-m-d') && $rtime == 1800) {
    $q = "BETWEEN '{$date} 00:00' AND '{$date} 23:30'";
  } else {
    $q = "IN (" . timeList($date, $rtime) . ")";
  }
  $table = getTable($date);   //echo $table;die();
  $sql = getQueryTag($db, $unit, $table, $q);  //echo "<br><b>time list :</b> $time_ls <br><b>table : </b> $table <br> <b>sql : </b> $sql"; //die();
  if (is_array($sql))
    return $sql;
  $rs = $db->_Execute($sql);  //echo "RS TAGS-DATA: <pre>"; print_r($rs);echo"</pre>"; die();

  if (!$rs)
    return array('ferror' => $db->ErrorMsg());
  else
    $tagsData = $rs->getArray();      //echo "<br>count array-->". count($tagsData) ."<br>"; 	echo "<pre>"; print_r( $tagsData);	echo "</pre>";    

  if (count($tagsData) == 0) {
    $error = ($report) ? "Tags Data Empty, but report $report[unit] $report[date] has created. is tags data has deleted?" : "Tags Data Empty";
    return array('error' => ($_GET['print']) ? "<div class=report_msg>$error</div>" : setMsg($error));
  }
  return $tagsData;
}

function getQueryTag($db, $unit, $table, $q, $export=false) {
  //$db->cacheFlush("select tagname from units as t1 join tagname as t2 on t1.id=t2.unit where code='{$unit}'");  #TESTTTTT
  $rs = $db->CacheGetAll(1000, "select alias from tagname as t1 join units as t2 on t1.unitId=t2.id where code='{$unit}'");
  //echo"QUERY TAGS:<PRE>";print_r($rs);echo"</pre>".count($rs); //die();
  if (!$rs)
    return array('error' => (($export) ? "Error getting tagname $unit. Or empty tagname" : setMsg("Error getting tagname $unit. Or empty tagname")));

  foreach ($rs as $i => $v) {
    //$qls[] = "[" . preg_replace("/[-.;]/ ", "_", $v[0]) . "]";
    //$qls[] = preg_replace("/[-.;]/ ", "_", $v[0]); // MYSQL
    //$qls[] = $v[0];  // CONVERT( DECIMAL(10,1), COLUMN )  OR CAST(COLUMN AS DECIMAL(10,1))
    $qls[] = "CAST($v[0] AS DECIMAL(10,2))";
  }
  if (!$export)
    return "SELECT CONVERT(VARCHAR(5), tanggal, 108)," . implode($qls, ',') . " FROM {$table} WHERE tanggal {$q}";
    # MYSQL
//     return "SELECT date_format(tanggal, '%H:%i')," . implode($qls, ',') . " FROM {$table} WHERE tanggal {$q}";
  else
    return "SELECT tanggal," . implode($qls, ',') . " FROM {$table} WHERE tanggal {$q}";
}

# function, api, report
function getQueryReport($db, $query = null, $pager = false, $api = false) {
	// if(!$db) $db = getDb();
  $db->SetFetchMode(ADODB_FETCH_ASSOC);
  $query = (!$api) ? "SELECT id,unit,dept,CONVERT(VARCHAR(10),date,111) as date,status,progress	FROM report {$query}" : "SELECT t1.id,unit,t3.label as unit_lbl,t2.label as dept,CONVERT(VARCHAR(10), date,111) as date,status,progress FROM report as t1 join depts as t2 on t1.dept=t2.code join units as t3 on t1.unit=t3.code {$query}";
  
	// MYSQL
//   $query=(!$api) ? "SELECT id, unit, dept, date, status, progress	FROM report {$query}" : "SELECT t1.id, unit, t3.label as unit_lbl, t2.label as dept, date, status, progress FROM report as t1 join depts as t2 on t1.dept=t2.code join units as t3 on t1.unit=t3.code {$query}"; // MYSQL
  if ($pager) {
    return getPager($db, $query, 5);
  } else
    return $db->_Execute($query);
}

# SELF INTERNAL FN ----------------------------------------------------------------------------------------------------------------------------------------------------------
function getQueryComment($db, $id = null, $select = null) {  //var_dump($id); die();
  $q_comment = ($select) ? "SELECT $select,t2.username,t2.fullname FROM comment as t1 join userlist as t2 on t1.uid=t2.id" : 'SELECT submit_date,  replace(comment, \'\"\', \'"\') as comment, username, isReject, report_id, t1.position, t2.username, t2.fullname	FROM comment as t1 join userlist as t2 on t1.uid=t2.id';
  if ($id)
    $q_comment .= " WHERE report_id" . ((is_int($id)) ? "={$id}" : " in({$id})");
  return $db->_Execute($q_comment . " order by submit_date asc");
}

function checkReport($report) {
  for ($i = 0; $i < count($report); $i++) {
    foreach ($report[$i] as $k => $v) {   //echo "<br>--->$k : $v";
      if (!isset($v)) {
        $report[$i]['error'][] = "Field not complete";
        break;
      }
    }
  }
  return $report;
}

function getBuildReport($db, $report, $mode, $qcomment = false) {  //echo "MODE: $mode , qcomment:$qcomment, <pre>";print_r($report);  echo"</pre>".count($report);  die();			# COBA CHECK DISINI !!!!!!!!!!!!
  // var_dump($db);
	$count = count($report);
  if ($count > 1) {
    foreach ($report as $k => $r) {
      $rpt_found[] = $r['id'];
    }
    $reportId = implode(",", $rpt_found);  //echo $report_found; die();
  } else
    $reportId = (int) $report[0]['id'];  //echo $reportId; var_dump(is_bool($reporId)); die();

  if ($reportId) {
    $report = checkReport($report); //echo" <pre>";print_r($report);  echo"</pre>"; die();
    $rs = ($qcomment) ? getQueryComment($db, $reportId, $qcomment) : getQueryComment($db, $reportId);

    if (!$rs){
      $err = $db->ErrorMsg();
    }else{
      $comments = $rs->getArray();
    }

    //echo "<b>getQueryComment : </b><pre>"; print_r($comments);echo "</pre>"; $x[trim($comments[0]['position'])]='x'; ECHO"==>";print_r($x); die();

    if ($mode == 'ls' || $mode == 'api') { # MODE API & LS REPORT
      $comments = buildComments($comments, $mode);
      //echo "<b>ARRAY Comment : </b><pre>"; print_r($comments);		echo "</pre>"; die();
      if ($count > 1) {
        foreach ($report as $i => $r) {   //echo "<b>$i : </b><pre>"; print_r($r);		echo "</pre>"; 
          $report[$i]['link'] = "reporting.php?unit={$r['unit']}&id={$r['id']}";
          $report[$i]['comment'] = ($comments[$r['id']]) ? $comments[$r['id']] : "Error Report with id:{$r['id']} - comments is missing ! please re-create report from begining";
        }
      } else {
        $report[0]['link'] = "reporting.php?unit={$report[0]['unit']}&id={$report[0]['id']}";
        $report[0]['comment'] = ($comments[$reportId]) ? $comments[$reportId] : "Error Report with id:{$report[0]['id']} - comments is missing ! please re-create report from begining";
      }
      //echo "<b>ARRAY Comment : </b><pre>"; print_r($report);echo "</pre>"; die();
      return $report;
    } else {
      if (empty($comments) || $err) {
        $report[0]['error'][] = ($err) ? $err : "Report id:" . $report[0]['id'] . " " . $report[0]['unit'] . " " . $report[0]['date'] . " is exist but comment is empty";
        return $report[0];
      }
      $report[0]['rejectBy'] = ($report[0]['id'] && $report[0]['progress'] == 0) ? getReject($comments) : null;
    }
  }

  if ($mode == 'pdf'){
    $report[0]['comment'] = buildDailyComment($report[0]['dept'], $comments, false, $report[0]['status']);
  }else{
    $report[0]['comment'][getPosCode()] = formatComment($comments, $report[0]['dept'], $report[0]['progress']);
  }
  # FORMAT COMMANT FOR 1 TAB (GABUNG ALL COMMENT)
  //echo "<pre>";print_r($report);echo"</pre>";  die();
  return $report[0];
}

function getReject($comments) {
  if ($comments) {     //echo "GET REJECTED COMMENT <pre>";print_r($comments);  echo"</pre>"; //die();
    foreach ($comments as $comment) {        //echo "<pre> $key "; print_r($comment);echo"</pre>";
      if ($comment['position'] != 'int')
        $rejectBy = ($comment['isReject']) ? array('name' => $comment['username'], 'position' => $comment['position']) : null;
    } //echo "===>"; print_r($rejectBy);
  }
  return $rejectBy;
}

# FOR ACTIVE USER, PRINT PDF, TIMELINE PENDING REPORT MODE

function buildDailyComment($dept, $comments=false, $input=false, $status) {  //echo "$dept $status <b>comment : </b> <pre>"; print_r($comments); echo "</pre>"; die();
  if ($comments) {
    foreach ($comments as $c) {
      //$list[$c['position']] = ($input) ? array('submit' => $c['submit_date'], 'name' => $c['fullname'], 'comment' => $c['comment']) : $c; //array("pos"=>$c[1],"submit"=>$c[2],"name"=>$c[3],"isRjt"=>$c[4],"comment"=>$c[5]);
			$list[$c['position']] = ($input) ? array('submit' => $c['submit_date'], 'name' => $c['fullname']) : $c; 
    }
    if (!$input) {
      $owner_list = (tab3($dept)) ? array('int', 'spv_eng', 'spv_qa') : array('int', 'spv_int', 'spv_eng', 'spv_qa');
      foreach ($owner_list as $owner) {  //echo  "_{$owner} --><pre>";  print_r($list["_{$owner}"]); echo "</pre>";
        if (!$list[$owner]){
          $list[$owner] = array("comment" => $status==1 ? '<i>-</i>' : '<i>pending</i>');
				}
      }
    }              //echo "<pre>"; print_r($list); echo"</pre>"; die();
  }
  else {
    if (!$input)
      $list = (tab3($dept)) ? array('int' => array('comment' => '-'), 'spv_eng' => array('comment' => '-'), 'spv_qa' => array('comment' => '-')) : array('int' => array('comment' => '-'), 'spv_int' => array('comment' => '-'), 'spv_eng' => array('comment' => '-'), 'spv_qa' => array('comment' => '-'));
  }
  return $list;
}

function buildComments($comments = false, $mode) {  //echo "<b>comment : </b> <pre>"; print_r($comments); echo "</pre>"; die();
  foreach ($comments as $c) {    //echo "<br> $c[report_id]";
    if ($mode == 'api')
      $list[$c['report_id']][] = $c;
    else
      $list[$c['report_id']][$c['position']] = $c;# with key position
  }
  return $list;
}

function formatComment($comments, $dept, $progress) {  //echo "formatComment - comment : <pre>";print_r($comment);  echo"</pre> progress : $progress";	//die();
  $content = existComment($comments, $dept, $progress); //echo "<b>existComment : </b><pre>";print_r($content);  echo"</pre>"; die();

  if (activeUser($progress)) {
    $content .= "<div id='cmt-con'><div id='cmt-form'> <textarea name='comment' id='comment'>{$_POST['comment']}</textarea> </div>"
        ."<div id='cmt-act'> <div class='panel3' style='height:31px'> <i class='fa fa-user'></i><span>" . getPosLabel(getPosCode())
        ."</span></div>"

        // NEW DIGITAL SIGNATURE
        ."<div class='pic-cmnt' style='padding-top:50px'> <button id='sign' class='btn btn-sign'>Sign</button> </div>";

        //."<div class='pic-cmnt'>" . (($_SESSION['user']['sign'] != ' ') ? "<img src='images/sign/{$_SESSION['user']['sign']}' class='user'>" : "<img class='user nopic' alt='No Signature Picture'>")
        //."<br>{$_SESSION['user']['fullname']}</div>";

    $content .= "<div id='submit' style='margin-top:-50px'>" . (($_SESSION['user']['position'] == 'int' && $progress == 0) ? "<span class='approve btn btn-primary'> <i class='newReport'></i> Submit report</span>" : "<div class='btn-group'><span class='approve btn btn-primary'>Approve</span> <span class='reject btn btn-danger'>Reject</span> </div>") . "</div> </div> <div class='clear'></div></div>";
  }
  //echo "<div>{$content}</div>"; //exit;

  return "<div>{$content}</div>";
}

function formatComment1($comments, $dept, $progress) {  //echo "formatComment - comment : <pre>";print_r($comment);  echo"</pre> progress : $progress";	//die();
  $content = existComment($comments, $dept, $progress); //echo "<b>existComment : </b><pre>";print_r($content);  echo"</pre>"; die();

  if (activeUser($progress)) {
    $content .= "<div id='cmt-con'><div id='cmt-form'> <textarea name='comment' id='comment'>{$_POST['comment']}</textarea> </div>" .
        "<div id='cmt-act'> <div class='panel3' style='height:31px'> <i class='fa fa-user'></i><span>" . getPosLabel(getPosCode()) . "</span></div>" .
        "<div class='pic-cmnt'>" . (($_SESSION['user']['sign'] != ' ') ? "<img src='images/sign/{$_SESSION['user']['sign']}' class='user'>" : "<img class='user nopic' alt='No Signature Picture'>") .
        "<br>{$_SESSION['user']['fullname']}</div>";
    $content .= "<div id='submit'>" . (($_SESSION['user']['position'] == 'int' && $progress == 0) ? "<span class='approve btn btn-primary'> <i class='newReport'></i> Submit report</span>" : "<div class='btn-group'><span class='approve btn btn-primary'>Approve</span> <span class='reject btn btn-danger'>Reject</span> </div>") . "</div> </div> <div class='clear'></div></div>";
  }
  echo "<div>{$content}</div>"; //exit;

  return "<div>{$content}</div>";
}

function activeUser($p) {  //var_dump($p);  #report.tpl
  $p = (is_array($p)) ? $p['p'] : $p;
  $pos = $_SESSION['user']['position'];
  $dept = $_SESSION['user']['dept'];
  return (($pos == 'int' && $p == 0) || ($pos == 'spv' && $dept != 'eng' && $dept != 'qa' && $p == 1) || ($pos == 'spv' && $dept == 'eng' && $p == 2) || ($pos == 'spv' && $dept == 'qa' && $p == 3));
}

function existComment($comments, $dept, $progress) {   //echo "<b>existComment - comment</b> : <pre>"; print_r($comments); echo "</pre>"; exit;
  $content = '';
  #BUILD INPUT COMMENT FOR EMAIL COMTENT
  if (activeUser($progress)) {  
    $inputs = buildDailyComment($dept, $comments, true);  //echo "====>inputs:"; print_r($inputs);
    $content .= ($inputs) ? "<textarea class='hide' name='comments'>" . json_encode($inputs) . "</textarea>" : "";
  }
  $count = count($comments);
  if ($count == 0) {
    if ($progress == 0 && $_SESSION['user']['position'] != 'int')
      $content .= "<div><div class='disabled'>Not Created</div></div>";
  }
  elseif ($count > 1) {
    #TOGGLE ALL IF COUNT > 1
    //$content .= "<b class='right toggle'> Show All Comments</b> <span class='toggleIcon ui-icon ui-icon-plusthick right'></span> <div class='clear'></div>";
    $content .= "<div class='right toggle'><i class='fa fa-plus-square'></i> <b>Show All Comments</b></div>";
    $content .= "<div style='overflow:auto;max-height:200px;text-align:left;clear:right'> <div id='comment_accord' class='hide'>";

    $last = array_pop($comments);
    foreach ($comments as $i) {         //echo"<B>COMMENT:</B> <pre>";print_r($i);echo"</pre>";
      $content .= "<div><span class='pos'>" . getPosLabel($i['position']) . "</span> <span class='date'>$i[submit_date]</span> <span class='right txt'>$i[fullname]</span>";
      $content .= ($i['isReject']) ? "<span class='right isReject' title='rejected'></span>" : "";
      $content .= "</div> <div class='ui-helper-clearfix'>$i[comment]</div>";
    }
    $content .= "</div></div>";
    $content .= "<div class='accordion'><div><span class='pos'>" . getPosLabel($last['position']) . "</span> <span class='date'>$last[submit_date]</span> <span class='right txt'>$last[fullname]</span>";
    $content .= ($last['isReject']) ? "<span class='right isReject' title='rejected'></span>" : "";
    $content .= "</div><div class='ui-helper-clearfix'>$last[comment]</div></div>";
  } else {
    $content .= "<div class='accordion'><div><span class='pos'>" . getPosLabel($comments[0]['position']) . "</span> <span class='txt'>{$comments[0][submit_date]}</span> <span class='right txt'>{$comments[0][fullname]}</span>";
    $content .= "</div><div>{$comments[0][comment]}</div></div>";
  }
  return $content;
}

?>
