<?php 
if($progress==4 && $_SESSION['user']["dept"]=='qa' && $_SESSION['user']["position"]=='spv') return;
#----------------- TEST PURPOSE
//if(isset($_POST['comments'])) print_r(json_decode($_POST['comments'])->int);
//echo "<b>------------ EMAIL----------</b></BR> progress:$progress</br>dept name:$dept_label</br>date:$date</br>unit:$unit</br>status:$status</br>pos:$pos<br>comment:$comment <br>
//unit name:$unit_label spv:". $_SESSION['user']['spv'];
// $setting=require(realpath('lib/emailSetting.php'));
#------------------------------------------------------------------------------------------------------------
#$setting=mailCfg($db); //echo"<pre>"; print_r($setting); echo "</pre>"; die(); #2592000 1month
# SELECT fullname, email FROM userlist WHERE (dept='prod' or dept='eng' or dept='qa') and position='spv';

if($_SESSION['mailcfg']['error']){ 
	return $mail=array('error'=>$_SESSION['mailcfg']['error'],'debug'=>"");
}

if($progress==0){   //echo "<br>"; print_r($_POST['comments']);
	//$int = json_decode(preg_replace(array('/\<\\\\\//', '/\>/', '/\\\/','/\n/'), '', $_POST['comments']))->int->name;  echo "=========>$int"; die();
	$int = json_decode(str_replace('\\', '', $_POST['comments']))->int->name; 
  $recip="fullname='{$int}' OR dept='$dept' and position='int' ";
}elseif($progress==1){
  $recip = ( trim($_SESSION['user']['spv']) && $dept==$_SESSION['user']['dept']) ? "id in({$_SESSION['user']['spv']})" : "dept='$dept' and position='spv'";
}elseif($progress==2){
   $recip=(trim($_SESSION['user']['spv'])&& $dept=='eng') ? "id in({$_SESSION['user']['spv']})" : "dept='eng' and position='spv'";
}elseif($progress==3)
  $recip="dept='qa' and position='spv'";
else $recip = "(dept='$dept' or dept='eng' or dept='qa') and position='spv'";
$rs= $db->_Execute("SELECT fullname, email FROM userlist WHERE $recip AND status=2");   
if(!$rs)
	return $mail['error']="Sending mail error : ".$db->ErrorMsg();
else{
	$recip=$rs->getArray();  //echo "SENDING TO :<pre>"; print_r($recip);echo"</pre>";
	if(count($recip)==0) return $mail['error']="Email recipients is empty. please set atleast one recipient";

	foreach($recip as $k=>$v){  //echo "<br>==>$k"; print_r($v);
		if($v[0]) $to[$v[0]]=$v[1];
		else $to[$v['fullname']]=$v['email'];
	}  
	//$to =array('Engineer Supervisor 1'=>'tona_atonix@yahoo.com', 'Engineer Supervisor 2' =>'anthon.awan@yahoo.com'); # BUAT TEST  XXXXXXX
	
	$lapor=(!$_POST['id']) ? "kami laporkan":"laporan";
	if($_SESSION['user']['position']=='spv')
		$r=($_POST['isReject']) ? "kami <b style='color:red'>reject</b>":"kami <b style='color:blue'>approve</b>";
	else $r=($_POST['id']) ? "kami revisi":"";

	$body="<style>
.panel{padding:2px;background:#1484BF;min-height:28px;color:white;text-align:center;margin-bottom:10px}
table{width:100%;border-spacing:0px;background-color:white;}
table tr td, table tbody tr td:not([align='center']){text-align:left}
table tr td.comment{margin:0px}
table.email{font-size:12px;min-width:700px;}
table.email tbody tr th{text-align:left}
table.email.summary{font-size:10px}
table.email.summary tbody tr th{text-align:center;padding:2px 0px;background-color:#BDC2C5}
table.email.summary tr td{padding:5px;border:1px solid #BDC2C5;border-left:white;border-top:white;}</style>
	
	<div>
		<div class='panel' style='padding:5px;text-align:left;min-height:0'>DAILY REPORT - BMS</div>
		<p> <b>PT. Pfizer Indonesia (factory)</b><br> <small>Jl. Raya Bogor Km. 28, Pasar Rebo,Jakarta Timur 13710,<br/> Indonesia</small> </p><br>
		<p>Salam Hormat, <br>Dengan ini $lapor daily report BMS, $r dengan data sebagai berikut :</p><br>

		<table class='email'>
			<tr><th width=110'>Date of report</th> <th width=5>:</th><td>{$date}</td></tr>
			<tr><th>Departement</th> <th>:</th><td>{$dept_label}</td></tr>
			<tr><th>Unit</th> <th>:</th><td>{$unit_label}</td></tr>
			<tr><th>Status</th> <th>:</th><td>".getStatus($status)."</td></tr>
			<tr><th>Submit Date</th> <th>:</th><td>".date('d/m/Y H:i')."</td></tr>
      <tr><th>Position</th> <th>:</th><td>".getPosLabel($pos)."</td></tr> 
			<tr><th>Comment</th> <th>:</th><td class='comment'>{$comment}</td></tr>
		</table>";

	// if(isset($_POST['comments'])){
		// $comments=json_decode($_POST['comments']); 	echo"POST-COMMENT: <pre>"; print_r($comments); echo "</pre> COUNT:".count($comments);
		// if(count($comments)){
      // foreach($comments as $i=>$c){   //var_dump(is_object($c));
        // if(is_object($c)){
          // $sc .="<tr><td>".getPosLabel($i)."</td><td> $c->name</td><td align='center2'>". date('d/m/Y H:i', strtotime($c->submit))."</td><td class='comment'> $c->comment</td></tr>";
        // }else{$sc .="<tr><td>".getPosLabel($i)."</td><td colspan=3 align='center'>$c</td></tr>";}
      // }
      // $body .="<br><b>Progress Summary</b> (previous comment) 
        // <table class='email summary'>
          // <tr><th width='150'><b>Position</th><th><b>Name</th><th width='150'><b>Submit date </b> </th><th style='min-width:300px'>Comment</th></tr>
          // $sc
        // </table>";
    // }
  // }
	$body .="<br><p>Demikian <a href='".$_SERVER['HTTP_REFERER']."' style='text-decoration:underline'>laporan</a> ini kami sampaikan,";
	if($progress < 4){ 
		$body .=" mohon ".($_POST['isReject'] ? "revisi":"approval")." dari anda</a>.";
	}
	$body .=" Terima kasih atas perhatiannya.</p><br><p><b>Hormat Kami,</b><br>".
	( trim($_SESSION['user']['sign']) ? "<img src='http://aspja2w003/bms3/images/sign/{$_SESSION['user']['sign']}' width='80' height='80'></img> <br>" : "")
	.$_SESSION['user']['fullname']."</p></div>";
	echo "<br>TO:"; print_r($to); echo "</br>body:".$body."</br>"; //die();
	require 'initMail.php'; 																																	
	$mail=sendMail("Daily Report - BMS", $body, $to, $_SESSION['mailcfg']); 
}
?>
