<?php  //echo "<pre>";print_r($_SERVER);echo"</pre>"; die();
include_once("verifyLogin.php");
if($_SESSION['user']['position']!=='admin') header("location: ./noPrivilege.php");
 
include_once("lib/Smarty/libs/Smarty.class.php");
include_once("function.php");
$smarty=new Smarty;//$db->debug=true;//$smarty->debugging=true;
$smarty->setCaching(Smarty::CACHING_LIFETIME_SAVED);
$smarty->setCacheLifetime(86400);
$smarty->setCompileCheck(false);
$db = getDb();  //$db->debug=true;
$db->SetFetchMode(ADODB_FETCH_ASSOC); //$db->debug=true;
	
if($_POST['q']){
	$uname=$_POST['q']['uname'];	
	$sql=buildQuery($_POST['q'], array('id'=>'t2.id','dept'=>'dept','uname'=>'username','dt'=>'date','event'=>'event','ds'=>'date','de'=>''));
	$query="select t1.id, date, username, dept, event from userlog as t1 join userlist as t2 on t1.userid=t2.id $sql[q] ORDER BY date DESC";
}
else{
	if($_GET['u']){
		$uname=$_GET['u'];
		$sql=" WHERE t2.username='$uname'";
	}
	$query="select t1.id, date, username, dept, event from userlog as t1 join userlist as t2 on t1.userid=t2.id $sql ORDER BY date DESC";
}

if($_POST['print']){
	$rs=getPager($db, $query, 1000, $_POST['print']);	//echo"<b>RS:</b><pre>";print_r($rs);echo"</pre>"; die();
}else{
	$rs=getPager($db, $query, 10, $_POST['print']);	//echo"<b>RS:</b><pre>";print_r($rs);echo"</pre>"; die();
}
	
if($rs['error']){
	$msg[]=$rs['error'];
}
else{
	$data['users']=$rs['rs']->getArray();
	$data['pager']=$rs['pager'];
	$data['count']=$rs['totalCount'];
	$data['pages']=$rs['pageCount'];
	$rs['rs']->Close();	
	$rs=null;
		
	if(count($data['users'])==0)
		$msg[]='Report Empty';
  $smarty->registerPlugin("function","dept", "getDept");
}

if($_POST['print']){
	//usrlog("Print UserLog $uname",$db);
	$smarty->assign("q", array('uname'=>$uname, 'print'=>1), true);
	$smarty->assign("data", $data, true);  //print_r($data); die();
	//$smarty->display("userlog.tpl"); die();  # buat test
	$html=$smarty->fetch("test.html"); //echo $html; die();
	
	//$colsAtr=array('A'=>array('width'=>'AT','align'=>'C'),'C'=>array('width'=>'AT'),'D'=>array('width'=>'AT'));
	//$setting=array('label'=>"Userlog $uname", 'headRows'=>2, 'colsAtr'=>$colsAtr);
	//printXls($html, $data['pages'] ." of ". $data['count']." Records", $setting);
	
	#PDF
	$file = "Userlog $uname";
  $descriptorspec = array(
    0 => array('pipe', 'r'), // stdin
    1 => array('pipe', 'w'), // stdout
    2 => array('pipe', 'w'), // stderr
  );
	//$process=proc_open('C:\wkhtmltopdf\bin\wkhtmltopdf.exe -q - -', $descriptorspec, $pipes);
	$process=proc_open('C:\wkhtmltopdf\bin\wkhtmltopdf.exe -q -L 4 -R 4 -T 4 -B 4 --javascript-delay 1000 - -', $descriptorspec, $pipes);
  //$process = proc_open('C:\wkhtmltopdf\bin\wkhtmltopdf.exe -q --title "aaa" - -', $descriptorspec, $pipes);
  //$process=proc_open('C:\wkhtmltopdf\bin\wkhtmltopdf.exe wkhtmltopdf -q -L 2 -R 2 -T 1 -B 1 --javascript-delay 1000 --debug-javascript --enable-javascript - -', $descriptorspec, $pipes);
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
    header('Content-Disposition: inline; filename="' . $file . '.pdf";');
    header('Cache-Control: public, must-revalidate, max-age=0'); // HTTP/1.1
    header('Pragma: public');
    header('Expires: Sat, 26 Jul 1997 05:00:00 GMT'); // Date in the past
    header('Last-Modified: ' . gmdate('D, d M Y H:i:s') . ' GMT');
    header('Content-Length: ' . strlen($pdf));
    echo $pdf;
  }
}
else{
	//usrlog("Access UserLog $uname",$db);
	$data['msg']=($msg) ? setMsg($msg, 'ui-state-highlight',null,null,'ui-icon-info') : null;
	$smarty->assign("data", $data, true);
	$q=array('uname'=>$uname,'depts'=>deptLabel(),'page'=>$_POST['r_page']);
	if(isset($sql['qval'])) $q=array_merge($q,$sql['qval']);
	$smarty->assign("q", $q, true);
	$smarty->assign("page", array('title'=>"BMS-Userlog $uname",'content'=>"userlog.tpl"), true);
	$smarty->assign("menu", array('list'=>$_SESSION['user']["menu"],'chid'=>($_SESSION['user']['position']=='admin') ? 'admin' : $_SESSION['user']['priviledges']));
	$smarty->display("layout.tpl");		
} 
?>
