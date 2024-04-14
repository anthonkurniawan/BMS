<?php
include("verifyLogin.php");
require("lib/Smarty/libs/Smarty.class.php");
include("function.php");
require_once('His.php');

$smarty=new Smarty;//$smarty->debugging=true;
$smarty->caching=true;
$smarty->cache_lifetime=86400;

// echo "<pre>";print_r($_SESSION['user']); echo "</pre>"; die();
$smarty->assign("menu", array('list'=>$_SESSION['user']["menu_his"],'chid'=>($_SESSION['user']['position']=='admin') ? 'admin_his' : $_SESSION['user']['priviledges']));

if($_GET['unit']){
	$date = isset($_GET['date']) ? $_GET['date'] : null;
	$priv = accesspriv($dept);
	// $report = getReport($db, $priv, null, $_GET['unit'], $dept, $_GET['print']);
	
	$hist = new Historian($_GET['unit'], $date);
	$hist->getDataHis();
	
	$report = ['date'=>$hist->date, 'area'=>$hist->areaName, 'data'=>$hist->data,'file_tpl'=>$hist->areaName.".tpl", 'error'=>$hist->error, 'isDialog'=>false];
	$tab3 = tab3($dept);
	$tabAttr = getActiveTab($tab3);
	$attr = array("tab3" => $tab3, "statusDis" => $statusDis, "tabAttr" => $tabAttr, "reportSum" => getSumProgress($report[0]["progress"], $report[0]["rejectBy"]), 'print' => $print);
	// echo '<pre>'; print_r($report); echo '</pre>';exit;
	
	$smarty->assign("report", $report, true);
	$smarty->assign('page', array('title' => "BMS-" . $hist->areaName, "content" => "reporting_his.tpl"), true);
	$smarty->registerPlugin("function", "tdata", "tdata");
	$smarty->display("layout.tpl");
}
else if($_POST['trend']){
	$hist = new Historian($_POST['unit']);
	$hist->startTime = $_POST['startTime'];
	$hist->endTime = $_POST['endTime'];
	$hist->time_marker = $_POST['time_marker'];
	$hist->interval = $_POST['interval'];
	if($_POST['samplingMode']) $hist->samplingMode = $_POST['samplingMode'];
	
	$hist->getDataHis();
	// echo "<pre>";print_r($hist->data); echo "</pre>"; die();
	// foreach($hist->data as $k=>$v){
		// echo $v['time'], " => ", date('Y-m-d H:i', strtotime($v['time'])), "<br>";
	// } die();
	$report = [
		'area'=>$hist->areaName, 
		'date'=>$hist->date,
		'startTime'=>$hist->startTime,
		'endTime'=>$hist->endTime,
		'time_marker'=>$hist->time_marker,
		'interval'=>$hist->interval,
		'data'=>$hist->data,
		'error'=>$hist->error,
		'isDialog'=>true
		// 'file_tpl'=>$hist->areaName.".tpl", 
	];
	$smarty->assign("report", $report, true);
	// $smarty->assign('page', array('title' => "BMS-" . $hist->areaName, "content" => $hist->areaName.".tpl"), true);
	$smarty->registerPlugin("function", "tdata", "tdata");
	$smarty->display($hist->areaName.".tpl");
}
else if($_POST['trend-table']){
	$hist = new Historian($_POST['unit']);
	// $hist->startTime = $_POST['startTime'];
	// $hist->endTime = $_POST['endTime'];
	// $hist->time_marker = $_POST['time_marker'];
	// $hist->interval = $_POST['interval'];
	// $hist->samplingMode = $_POST['samplingMode'];	
	// $hist->getDataHis();

	$report = [
		'area'=>$hist->areaName, 
		'date'=>$hist->date,
		// 'startTime'=>$hist->startTime,
		// 'endTime'=>$hist->endTime,
		// 'time_marker'=>$hist->time_marker,
		// 'interval'=>$hist->interval,
		// 'data'=>$hist->data,
		// 'error'=>$hist->error,
		'isDialog'=>true,
		'isTrendTable'=>true
	];
	$smarty->assign("report", $report, true);
	// $smarty->assign('page', array('title' => "BMS-" . $hist->areaName, "content" => $hist->areaName.".tpl"), true);
	$smarty->registerPlugin("function", "tdata", "tdata");
	$smarty->display($hist->areaName.".tpl");
}
else{
	$data['msg'] = setMsg("Historian Data",'ui-state-default',null,"padding:20px 10px;font-size:20px;width:550px;margin-top:200px",'ui-icon-info');
	$smarty->assign("data", $data, true); 
	$smarty->assign("page", array('title'=>'Historian Data','content'=>"done.tpl"),true);
	$smarty->display("layout.tpl");
}

/** FUNCTION TEMPLATE FOR DAILY PRINT * */
function tdata($param){
	$v=$param['v']; $dec= isset($param['d']) ? $param['d'] : 0;
	if($v===null) return '<td class="txtErr">n/a</td>';
	$val = $dec ? number_format($v, $dec, '.', '') : ( $v > 999.99 ? number_format($v, 0, '', '') : number_format($v, 1, '.', ''));
	$cond=isset($param['c']) ? getCond($param['c'], $val) : true;  //var_dump($cond);
	$td = $cond ? '<td>'.$val.'</td>' : '<td class="txtErr">'.$val.'</td>'; 
	return $td;
}

function getCond($cond, $v){
	$c = str_replace('x', $v, $cond);
	return eval("return ($c);");
}

function getSumProgress($progress, $isReject) {
  if ($progress == 0 && $isReject == null) {
    return (($_GET['print'] == 'pdf') ? "<span class='newReport left'></span>" : "<i class='fa fa-file-o'></i>") . "<b>" . (($_SESSION['user']['position'] == 'int') ? "Create New Report" : "Not Created") . "</b>";
  } elseif ($progress == 4) {
    return "<span class='isApprove'></span> <b>Complete</b>";
  } else
    return "<span class='isPending'></span> <b>Not Complete</b>";
}
?>
