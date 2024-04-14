<?php
function sendMail($subject, $body, $to=array(), $setting ){	//echo"MAIL-SETTING:<pre>";print_r($setting);echo"</pre>";
	require 'lib/PHPMailer-master/PHPMailerAutoload.php';
	$mail=new PHPMailer();
	//$mail->IsMail();
	$mail->IsSMTP();
	$mail->IsHTML(true);
	$mail->Subject=$subject;
	$mail->Body=$body;
	foreach($to as $name=>$email){ $mail->AddAddress($email, $name); }
	
	if(isset($setting['Host']))
	  $mail->Host=$setting['Host'];
	if(isset($setting['Port']))
	  $mail->Port=$setting['Port'];
	if(isset($setting['From']))
	  $mail->From=$setting['From'];
	if(isset($setting['FromName']))
	  $mail->FromName=$setting['FromName'];
	if(isset($setting['SMTPSecure']))
	  $mail->SMTPSecure=$setting['SMTPSecure'];
	if(isset($setting['SMTPAuth']))
	  $mail->SMTPAuth=$setting['SMTPAuth'];
	if(isset($setting['Username']))
	  $mail->Username=$setting['Username'];
	if(isset($setting['Password']))
	  $mail->Password=$setting['Password'];
	if(isset($setting['addReplyTo']))
	  $mail->addReplyTo=$setting['addReplyTo'];
	if(isset($setting['SMTPDebug']) && $setting['SMTPDebug']!=0){
	  $mail->SMTPDebug=$setting['SMTPDebug'];
		if(isset($setting['Debugoutput'])){ $mail->Debugoutput=$setting['Debugoutput']; }
	}
	
	ob_start();
	$rs=$mail->Send();
	$debug=ob_get_contents();
	ob_end_clean();
	
	if(!$rs){
	  $rs=array("error"=>"Mail sending failed : " . $mail->ErrorInfo, 'debug'=>$debug);
	}else{
		$rs=array("success"=>"Mail send successfully..",'debug'=>$debug);
  }
	return $rs;
}
?>
