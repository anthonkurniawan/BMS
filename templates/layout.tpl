<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
{strip}
<html lang="en">
<head>
  <meta http-equiv="x-ua-compatible" content="IE=8,IE=edge,chrome=1"/>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<title>{$page.title}</title>
	<link rel="icon" href="favicon.ico" type="image/vnd.microsoft.icon"></link>
	<link rel="stylesheet" type="text/css" href="css/font-awesome-4.6.1/font-awesome.min.css"></link>
  <link rel="stylesheet" type="text/css" href="css/eflatmenu.min.css"></link>
  <!--<link rel="stylesheet" type="text/css" href="js/jquery-ui-1.11.4.custom/jquery-ui.min.css"></link>-->
  <link rel="stylesheet" type="text/css" href="js/jquery-ui-1.13.0.custom/jquery-ui.min.css"></link>
  <link href="css/style.css" rel="stylesheet" type="text/css"></link>
	<script type="text/javascript" src="js/jquery-1.12.3.min.js"></script>
	<!--<script type="text/javascript" src="js/jquery-3.6.0.js"></script>-->
	<!--<script type="text/javascript" src="js/jquery-ui-1.11.4.custom/jquery-ui.min.js"></script>-->
	<script type="text/javascript" src="js/jquery-ui-1.13.0.custom/jquery-ui.min.js"></script>
	<script type="text/javascript" src="js/selectivizr-1.0.2/selectivizr-min.js"></script>
  <noscript><link rel="stylesheet" href="[fallback css]" /></noscript>
  {*<!--  <script type="text/javascript" src="js/html5shiv.min.js"></script>
  <script type="text/javascript" src="js/respond.min.js"></script> -->*}
</head>
<body>

	<div id="page" class="tengah">
		{*MENU*}
		<div class="banner ui-helper-clearfix" style="padding:0px">
			<a id="touch-menu" class="mobile-menu2" href="#"><i class="fa fa-bars"></i>Menu</a>
			<nav class="menu2">
        {assign "home" 0 nocache}
        {include file="menu.tpl" cache_id="{$menu.chid}"}
        <ul class="eflat-menu b right">
          <li><a href="index.php"><i class="fa fa-home"></i>Home</a></li>
          <li><a href="about.php"><i class="fa fa-info-circle"></i>About</a></li>
          <li><a href="logout.php"><i class="fa fa-sign-out"></i>Logout</a></li>
        </ul>
			</nav>
		</div>
				
		<div id="content">
			{*MSG JS NOTIF*}
			<div id="msg-con" class="ui-corner-all ui-helper-clearfix">
				<div class="msg"></div>
				<a href="#" class="msgClose right ui-icon ui-icon-close"></a>
			</div>
					
			{*loader black*}
			<div id="loader" style="display:none">
				<div class="ui-widget-overlay"></div>
				<div class="ui-loader ui-corner-all ui-body-a ui-loader-verbose">
					<span class="ui-icon-loading"></span><h1>Loading..</h1>
				</div>
			</div>
			{include file=$page.content cache_id=$page.content} 
		</div>
		<div class="footer hide">Copyright &copy;<script type="text/javascript">document.write(new Date().getFullYear());</script> &nbsp;<a href="http://apac.ecf.pfizer.com/sites/PGMJakarta"> Pfizer Global Supply Jakarta</a></div> 
	</div>
	<script type="text/javascript" src="js/app.js"></script>
</body>
</html>
{/strip}
