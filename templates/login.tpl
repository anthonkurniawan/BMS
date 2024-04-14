<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
{strip}
<html>
<head>
  <meta http-equiv="x-ua-compatible" content="IE=8,IE=edge,chrome=1"/>
	<meta charset="utf-8"/>
	<title>BMS-Login</title>
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
		<div class="auth">
			<div id="msg-srv" style="min-height:31px;color:red;font-size:17px;"> {if $msg}{$msg}{/if}</div> <!-- KET ERROR --->
			<div class="box-bdr" style="overflow:hidden">
        <div class="ui-widget-header"><i class="fa fa-user"></i>Welcome, please login first</div>
          <form method="post" class="form" style="min-height:auto">
            <div class="left" style="width:22%"><img src="images/key.jpeg" style="width:110px;height:102px"></div>
            <div class="left" style="width:70%;margin-left:43px">
              <div class="row"><label for="username">Username</label><input name="username" type="text" value="{$username}" placeholder="Your Username"></div>
              <div class="row"><label for="password">Password</label><input name="password" type="password" placeholder="Your Password"></div>
            </div>
          <div class="clear"></div>
					<div class="ui-widget-header" style="text-align:center"><input name="login" type="image" src="images/button-login.jpg" width="70" height="25"> </div>
				</form>
			</div>
		</div>
		<div class="footer hide">Copyright &copy;{$year}<a href="http://apac.ecf.pfizer.com/sites/PGMJakarta"> Pfizer Global Supply Jakarta</a></div>
	</div>
</body>
</html>
{/strip}
