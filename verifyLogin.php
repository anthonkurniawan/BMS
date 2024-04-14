<?php
  @session_name("bms3");
  @session_start(); //print_r($_SESSION); die();
  if( !(isset($_SERVER['HTTP_X_REQUESTED_WITH']) && $_SERVER['HTTP_X_REQUESTED_WITH']=='XMLHttpRequest')){ 
		//echo $_SESSION["lastactivity"]." ". (time()-$_SESSION['lastactivity'])." ". ($_SESSION["lastactivity"]-time());
		$_SESSION["lastactivity"] = time();
	} //else header( "Location: ./logout.php" ); //echo $_SESSION["lastactivity"]." ". (time()-$_SESSION['lastactivity']);
	
	if((time() - $_SESSION["lastactivity"]) > 600){ //3600 seconds
		echo json_encode(array('timeout'=>true, 'error'=>'Your session has expired')); //die();
		exit;
	}
	if(!isset($_SESSION['user']["authenticated"])){  //echo "<pre>";print_r($_GET); print_r($_POST); print_r($_SERVER);echo"</pre>";die();
		if(isset($_SERVER['HTTP_X_REQUESTED_WITH']) && $_SERVER['HTTP_X_REQUESTED_WITH']=='XMLHttpRequest')
			echo json_encode(array('error'=>'no authorized'));
		else
			header( "Location: ./login.php" ); 
		exit;
	}
?>
