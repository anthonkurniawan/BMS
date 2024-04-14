<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
{strip}
<html lang="en">
<head>
  <meta http-equiv="x-ua-compatible" content="IE=8,IE=edge,chrome=1"/>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<title>BMS-Home</title>
	<link rel="icon" href="favicon.ico" type="image/vnd.microsoft.icon"></link>
	<script type="text/javascript" src="js/jquery-1.12.3.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.11.4.custom/jquery-ui.min.js"></script>
	<script type="text/javascript" src="js/report.js"></script>
	<script type="text/javascript" src="js/app.js"></script>
	<link rel="stylesheet" type="text/css" href="css/font-awesome-4.6.1/font-awesome.css"></link>
  <link rel="stylesheet" type="text/css" href="css/eflatmenu.min.css"></link>
  <link rel="stylesheet" type="text/css" href="js/jquery-ui-1.11.4.custom/jquery-ui.min.css"></link>
	<link href="css/style.css" rel="stylesheet" type="text/css"></link>
</head>
<body>  
	{*<div class="tengah" id="page" style="width:1048px;">*}
	<div class="tengah" id="page">
		{*header*}
		<div class="banner" style="padding:2px 0px;height:80px">
			<div><img src="images/logo_pfizer.png" class="logo" style="margin:5px;"/><b>Building Management System - Daily Report</b></div>
		</div>
		<div id="menu">		
		<div class="pic-banner">
      <img src="images/pic/engineering.jpg">
			<img src="images/pic/wfi.jpg"></img>
			<img src="images/pic/wpu.jpg"></img>
			<img src="images/pic/drycore.jpg"></img>
			<img src="images/pic/sterile.jpg"></img>
			<img src="images/pic/production.jpg"></img>
			<img src="images/pic/warehouse.jpg"></img>
			<img src="images/pic/qa.jpg"></img>
			<div style="background: black;color: white;padding: 56px 0 56px 0;">More + </div>
		</div>

		{*MENU*}
		<div class="right" class="right" style="width:626px;background:#000033">
			<a id="touch-menu" class="mobile-menu" href="#"><i class="fa fa-bars"></i>Menu</a>
			<nav class="menu1">
      {*
				<ul class="eflat-menu">
				{foreach $menu.list as $i=>$mn}
				{if isset($mn.url)}
					<li><a href="{$mn.url}">{$mn.label}</a></li>
				{else}
					<li>
						<a href="#">{$i}</a>
						<ul class="sub-menu">{foreach $mn as $m}<li><a href="{$m.url}">{$m.label}</a></li>{/foreach}</ul>
					</li>
				{/if}
				{/foreach}	
				</ul>
      *}
      {assign "home" 1 nocache}
      {include file="menu.tpl" cache_id="{$menu.chid}"}
			</nav>
		</div>
		<div class="right" style="width:30px;height:22px;background:url(images/menu.jpg) no-repeat;"></div>
		<div style="clear:right"></div>
		<div class="right textMenu">
			<strong>{$user.fname nocache}</strong> &nbsp;&nbsp;
			<a href="about.php"><i class="fa fa-info-circle"></i>About</a>&nbsp;&nbsp;&nbsp;&nbsp;
      <a id="logout" href="logout.php"><i class="fa fa-sign-out"></i>Logout</a>&nbsp;&nbsp; 
		</div>
		<div class="clear"></div>
    </div>
			
		{*content*}
		<div class="tengah" style="margin:0px 10px;padding:10px;min-height:270px;min-width:900px">
			<!--- MSG JS NOTIF --->
			<div id="msg-con" class="ui-corner-all ui-helper-clearfix">
				<div class="msg"></div>
				<a href="#" class="msgClose right ui-icon ui-icon-close"></a>
			</div>

			{if $msg}{$msg}{/if}

			{*---------------------------------------------------------- TEST -------------------------------------------------
			<div id="loading_parent"><span class="ajax_notification dismissable" id="ajax_message_num_17" style="cursor: pointer;"><div class="error">Some errors have been detected on the server!<div>Please look at the bottom of this window.<input id="pma_ignore_errors_popup" type="submit" value="Ignore" style="float: right;margin: 20px;"><input id="pma_ignore_all_errors_popup" type="submit" value="Ignore All" style="float: right;margin: 20px;"></div></div></span></div>
			-----------------------------------------------------------------------------------------------------------------*}
			<div id="pending-report"></div>
					
			{*welcome*}	
			<div class="box-bdr" style="margin-top:50px">
				<div class="ui-widget-header"><i class="fa fa-lg fa-home"></i>Welcome, {$user.fname nocache}</div>
					
				{*loader black*}
				<div id="loader" class="hide">
					<div class="ui-widget-overlay"></div>
					{*<div class="ui-widget-shadow ui-corner-all" style="width: 302px; height: 152px; position: absolute2; left: 50px; top: 30px;margin: auto;">Loading..</div>*}
					<div class="ui-loader ui-corner-all ui-body-b ui-loader-verbose">
						<span class="ui-icon-loading"></span><h1>Loading..</h1>
					</div>
				</div>
					
				<div class="textNormal ui-widget-content">
					Welcome to Pfizer PGS Jakarta Building Management System - Daily Report <br/>Please choose any menu above<br/><br/>Your privilege: {$user.privilege nocache}
				</div>
			</div>
		</div>
		<div class="footer hide">Copyright &copy;<script type="text/javascript">document.write(new Date().getFullYear());</script> &nbsp;<a href="http://apac.ecf.pfizer.com/sites/PGMJakarta"> Pfizer Global Supply Jakarta</a></div>
	</div>
</body>
</html>
{/strip}
