<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
{strip}
<html>
<head>
  <meta http-equiv="x-ua-compatible" content="IE=8,IE=edge,chrome=1"/>
	<meta charset="utf-8"/>
	<title>BMS-Logout</title>
	<link rel="icon" href="favicon.ico" type="image/vnd.microsoft.icon"></link>
  <script type="text/javascript" src="js/jquery-1.12.3.min.js"></script>
  <script type="text/javascript" src="js/jquery-ui-1.11.4.custom/jquery-ui.min.js"></script>
  <script type="text/javascript" src="js/app.js"></script>
  <link rel="stylesheet" type="text/css" href="js/jquery-ui-1.11.4.custom/jquery-ui.min.css"></link>
	<link rel="stylesheet" type="text/css" href="css/font-awesome-4.6.1/font-awesome.css"></link>
	<link href="css/style.css" rel="stylesheet" type="text/css"></link>
</head>
<body>  
	<div id="page">
		<div class="banner"><img src="images/logo_pfizer.png" class="logo">&nbsp;<b>Building Management System - Daily Report</b></div>
		<div class="auth" style="margin-top:160px">
			<div class="box-bdr">
				<div class="ui-widget-header"><i class="fa fa-lg fa-power-off"></i>Logout</div>
				<div class="ui-widget-content"><h3>You are currently logout from BMS</h3></div>
			</div>
		</div>
		<script language="JavaScript" type="text/javascript">window.setTimeout('window.location="login.php"; ', 1000);</script>
		<div class="footer hide">Copyright &copy;{$year}<a href="http://apac.ecf.pfizer.com/sites/PGMJakarta"> Pfizer Global Supply Jakarta</a></div>
	</div>
</body>
</html>
{/strip}
