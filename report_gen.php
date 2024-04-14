<?php
include("verifyLogin.php");
include("function.php");
$usrDept = $_SESSION['user']["dept"];
$usrPos = $_SESSION['user']["position"];
$unit = $_GET['unit'];
$u = unitData($unit);
$dept = $u['dept'];

if (!$dept) {
  header("location: done.php?msg=Invalid request!");
  die();
}
$priv = accesspriv($dept);
$access = (($priv) || ($usrPos == 'spv' && $usrDept == 'eng' && $_GET['id'] != '') || ($usrPos == 'spv' && $usrDept == 'qa' && $_GET['id'] != '')); //echo "<br>ACCESS : "; var_dump($access);  die();
if (!$access)
  header("location: ./noPrivilege.php");

require("lib/Smarty/libs/Smarty.class.php");

$smarty = new Smarty;
$smarty->caching = true;
$smarty->cache_lifetime = 86400;

if ($_POST['kirim']) {
  $data = validateInput($_POST, array('status', 'comment'));
  if (!$data['error']) {
		if ($data['id']) {
      if ($data['isReject'] == 1) {
        $progress = 0;
      } elseif ($data['progress'] == 0) {
				$progress = ($dept == 'eng' || $dept == 'qa') ? 2 : 1;
      } else {
        $progress = $data['progress'] + 1;
      }
    } 
    elseif ($data['status']==1){ 
			$progress = 4;
    }else{ 
			$progress = ($dept == 'eng' || $dept == 'qa') ? 2 : 1;
    }
    $rs = report($db, $priv, $progress, $u['dept_lbl'], $unit, $dept, $u['unit_lbl']);
    usrlog($rs['info'], $db);
    if ($rs['error']) {
      $msg = array('error' => $rs['info']);
    } else {
      exit;
    }
    $rs = null;
  } else
    $msg['error'] = $data['error'];
}
else if (($_GET['id'] || $_GET['date']) || $_GET['print']) {
  $report = ($id) ? getReport($db, $priv, $id) : getReport($db, $priv, null, $unit, $dept, $_GET['print']);
  if ($report[0]['date']) {
    if (isset($msg['error'])) {
      $report[0]['error'] = ($report[0]['error']) ? array_merge($report[0]['error'], $msg['error']) : $msg['error'];
    }
    if (isset($report[0]['error'])) {
      $report[0]['error'] = setMsg($report[0]['error'], 'ui-state-error', null, null, 'ui-icon-alert');
    }
    $tab3 = tab3($dept);
    if (!$_GET['print']) {
      $statusDis = ($usrPos == 'int' && $report[0]['progress'] == 0) ? "" : "disabled";
      $tabAttr = getActiveTab($tab3);
      $print = "reporting.php?unit=" . $report[0][unit] . "&" . (($report[0]['id']) ? "id=" . $report[0]['id'] : "date=" . $report[0]['date']);
      $attr = array("tab3" => $tab3, "statusDis" => $statusDis, "tabAttr" => $tabAttr, "reportSum" => getSumProgress($report[0]["progress"], $report[0]["rejectBy"]), 'print' => $print);
      $tabDis = ($report[0]['progress'] == 0 && $usrPos != 'int' && $report[0]['rejectBy'] == '') ? true : $tabAttr['disabled'];
      $sc = "new report({$tabAttr['active']}, $tabDis, {$report[0]['progress']}, '{$report[0]['rejectBy']['position']}');"; //echo "tab-dis:$tabDis, progress:$progress, rejectBy:$rejectBy, sc:$sc"; //die();
    } 
    else {
      if ($_GET['print'] == 'pdf') {
        foreach ($report[0]['comment'] as $k => $c) {
          $cmt .= "<div class='comment'>
						<div class='comment-h'>
							<div class='left'><b>" . getPosLabel($k) . (($c['fullname']) ? ", </b>$c[fullname]" : "</b>") . "</div> <div class='left'>$c[submit_date]</div>" .
              ((isset($c['isReject'])) ? "<div class='right'>" . statusCmt($k, $c['isReject']) . "</div>" : "<div class='right null'>-</div>") .
              "<div class='clear'></div></div>
						<div class='comment-v'>$c[comment]</div>
					</div>";
        } 
        $report[0]['comment'] = $cmt;
        $cmt = null;
      }
      $smarty->registerPlugin("function", "statusCmt", "statusCmt");
    }
    $smarty->registerPlugin("function", "parse", "parseValue");
  } 
  else $error = $report['error'];
} 
else{ print_r($_GET); echo"<pre>";print_r($_SERVER);echo"</pre>"; 
	$url = $_SERVER['REQUEST_URI'].'&date='.date('Y-m-d');  echo "==>".$url;
	header("location: $url");
}

if ($error) {
  $error = (is_array($error)) ? $error : "$error. Please contact your administrator!";
  $error = setMsg($error, 'ui-state-error', null, 'padding:10px', 'ui-icon-alert');
}

$smarty->assign("unit", array('name' => $unit, 'label' => $u['unit_lbl'], 'file' => $unit . '.tpl', 'dept' => $dept, "priv" => $priv), true);
$smarty->assign("attr", $attr, true);
$smarty->assign("report", $report, true);
$smarty->assign('sc', $sc, true);
$smarty->assign("error", $error, true);

if ($_GET['print']) {
  $smarty->assign("print", $_GET['print'], true);
  $ket = ($report[0]['date']) ? date("d-m-Y", strtotime($report[0]['date'])) : 'error';
  $file = $u['unit_lbl'] . "-" . $ket;

  if ($_GET['print'] == 'xls') {
    $html = $smarty->fetch("reporting_print.tpl");
    $colsAtr = array('A' => array('width' => 'AT', 'align' => 'C'));
    $headEndR = ($unit == 'equipment' || $unit == 'lab' || $unit == 'lab_chemic' || $unit == 'lab_micro') ? 2 : 3;
    $setting = array('label' => $file, 'headRows' => ($error) ? 2 : $headEndR, 'colsAtr' => $colsAtr, 'colsize' => 13);
    printXls($html, ($report[0]['date']) ? date("F j, Y", strtotime($report[0]['date'])) : 'error', $setting);
  } elseif ($_GET['print'] == 'pdf') {
    $url = 'http://' . $_SERVER[HTTP_HOST] . dirname($_SERVER[PHP_SELF]);
    $smarty->assign("attr", array("tab3" => $tab3, "reportSum" => getSumProgress($report[0]["progress"], $report[0]["rejectBy"]), 'url' => $url), true);
    //$smarty->display("reporting_print.tpl"); die();  # buat test
    $html = $smarty->fetch("reporting_print.tpl");
    $descriptorspec = array(
        0 => array('pipe', 'r'), // stdin
        1 => array('pipe', 'w'), // stdout
        2 => array('pipe', 'w'), // stderr
    );
		
		$process = proc_open('xvfb-run -a wkhtmltopdf -q --javascript-delay 1000 - -', $descriptorspec, $pipes);
    // Send the HTML on stdin
    fwrite($pipes[0], $html);
    fclose($pipes[0]);

    // Read the outputs
    $pdf = stream_get_contents($pipes[1]);
    $errors = stream_get_contents($pipes[2]); //var_dump($pdf); die();
    // Close the process
    fclose($pipes[1]);
    $return_value = proc_close($process);
    if ($errors) {
      throw new Exception('PDF generation failed: ' . $errors);
    } else {
      header('Content-Type: application/pdf');
      header('Cache-Control: public, must-revalidate, max-age=0'); // HTTP/1.1
      header('Pragma: public');
      header('Expires: Sat, 26 Jul 1997 05:00:00 GMT'); // Date in the past
      header('Last-Modified: ' . gmdate('D, d M Y H:i:s') . ' GMT');
      header('Content-Length: ' . strlen($pdf));
      header('Content-Disposition: inline; filename="' . $file . '.pdf";');
      echo $pdf;
    }
  }
} else {
  $smarty->assign("user", array('name' => $_SESSION['user']["username"], 'fname' => $_SESSION['user']["fullname"], 'position' => $usrPos, 'dept' => $usrDept), true);
  $smarty->assign("menu", array('list' => $_SESSION['user']["menu"], 'chid' => ($_SESSION['user']['position'] == 'admin') ? 'admin' : $_SESSION['user']['priviledges']));
  $smarty->assign('page', array('title' => "BMS-" . $u['unit_lbl'], "content" => "reporting.tpl"), true);  // nanti  masing2 tpl-unit haspus aja. gani dgn variable table
  $smarty->display("layout.tpl");
}

/** FUNCTION TEMPLATE FOR DAILY PRINT * */
function parseValue($param){ 
	return ($param['v'] > 99.99 ? (int) $param['v'] : $param['v']);
}
function getSumProgress($progress, $isReject) {
  if ($progress == 0 && $isReject == null) {
    return (($_GET['print'] == 'pdf') ? "<span class='newReport left'></span>" : "<i class='fa fa-file-o'></i>") . "<b>" . (($_SESSION['user']['position'] == 'int') ? "Create New Report" : "Not Created") . "</b>";
  } elseif ($progress == 4) {
    return "<span class='isApprove'></span> <b>Complete</b>";
  } else
    return "<span class='isPending'></span> <b>Not Complete</b>";
}

function statusCmt($pos, $v) {
  if ($pos == 'int')
    return "submited";
  elseif ($v == 0)
    return "approved";
  else
    return "rejected";
}
?>
