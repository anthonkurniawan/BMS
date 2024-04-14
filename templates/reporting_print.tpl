{strip}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<head>
  <meta http-equiv="x-ua-compatible" content="IE=8,IE=edge,chrome=1"/>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
</head>

{if $print=='pdf'}
<style>
body{ margin:0px; padding:0; font-size:12px }
.left{ float:left }
.right{ float:right }
.clear{ clear:both }
.container{ border-width:1px 0px 0px 1px;display:block; position:relative }
table{ width:100%;border-spacing:0px;text-align:left;background-color:white;border-top:1px solid;border-left:1px solid }
table.print tr th{ border:1px solid;border-left:white;border-top:white;font-size:10px;background:#C3DEE4;text-align:center } 
table.print tr td{ border:1px black;border-left:white;border-top:white;border-style:solid;font-size:11px;padding:2px 1px; }
table.print tr td.txtErr{ text-align:center;color:red }
table.print2 tr th{ font-size:12px }
table.print2 tr td{ font-size:13px; }
input[type="checkbox"]{ margin: 0.2ex }
.comment{ margin-bottom:10px;border:1px solid #9BB4B9}
.comment-v, .comment-h{ padding:3px 5px;}
.comment-h{ border-bottom:1px solid #9BB4B9;background:#C3DEE4}
.comment-h div.left:first-child{ width:48%}
.comment-h .null{ margin-right:10px}
.isApprove, .isPending, .isReject, .newReport{ width:16px;height:16px;float:left;margin-right:3px}
.isApprove{ background-image:url("{$attr.url}/js/jquery-ui-1.11.4.custom/images/ui-icons_469bdd_256x240.png");background-position:-208px -192px}
.isPending{ background-image:url("{$attr.url}/js/jquery-ui-1.11.4.custom/images/ui-icons_f9bd01_256x240.png");background-position:-16px -144px} 
.isReject{ background-image:url("{$attr.url}/js/jquery-ui-1.11.4.custom/images/ui-icons_cd0a0a_256x240.png");background-position:0 -144px;}
.newReport{ background-image:url("{$attr.url}/js/jquery-ui-1.11.4.custom/images/ui-icons_222222_256x240.png");background-position:-48px -80px}
.report_msg{ margin-left:auto;margin-right:auto;text-align:center;width:500px;color:red;font-size:20px}
.sum{ font-size:14px;margin:0px 2px 0px 3px}
</style>
<body>
	<div class="header">
    <div id='mtop'></div>
		<div id="banner" style="display:table;width:100%;background:rgb(149, 171, 225) none repeat scroll 0% 0%;border:1px solid #5D89AB;">
      <img class="left" src="{$attr.url}/images/pgm.jpg" width="52" height="25"/>
			<span style="float:left;font-size:19px;color:white;padding-top:2px;margin-left:33%;">DAILY REPORT BMS</span>
		</div>
		<div class="h-desc" style="margin-top:5px;font-size:12px;font-weight:bold">
			<div class="left" id='test'>{$unit.label}</div>
			<div class="right">{$report.0.date|date_format:'%A, %B %e, %Y'}</div>
		</div>
		<div style="clear:both"></div>
	</div>

	{if $error} {$error} {/if}

	{if isset($report.tdata)}
	<div class="container">
		{include file=$unit.file}
	</div>
	
	<div id="add"></div>
			
	<div>
		<div style="margin:5px 0px">
			<div class="left">  
				<input type="checkbox" {if $report.0.status==2}checked{/if}> <span style="margin-right:5px">Deviasi</span>      									
				<input type="checkbox" {if $report.0.status==1}checked{/if}> <span>No Deviasi</span>
			</div>
			<!--<div class="right">{$attr.reportSum}</div>-->
			<div class="clear"></div>
		</div>
		{if $report.0.error} <div class="comment">{$report.0.error}</div>{/if}
		{$report.0.comment}

		{*<div class="comment">
			x<br>x<br>x<br>x<br>x<br>x<br>x<br>x<br>z<br>zx<br>1<br>2<br>3<br>4<br>5
		</div>*}

	</div>
	{/if}
{else}
	<h5>{$unit.label}</h5>
	{if $error}<table><tr><td>{$error}</td></tr></table>
	{else}
		{if $report.tdata}{include file=$unit.file}{/if}
	{/if}
{/if}
{if $print=='pdf'}
<script type="text/javascript">
(function(){
  if(!document.getElementsByClassName){
    document.getElementsByClassName = function(className){
      return this.querySelectorAll("." + className); 
    };
  }
    
	var h=document.body.scrollHeight; 
	/*document.getElementById("test").innerText=h; console.log(h);*/
	if(h > 1723){ /* 1855 -1586(html) - 1926(pdf) = -340 firefox 2377*/ /* 2042 * hitungan chrome: 1331	*OK di 2039 (chrome&firefox-linux) */
		var banner=document.getElementById('banner'), head=document.getElementsByClassName("header")[0], hd=document.getElementsByClassName("h-desc")[0];
		document.body.style.fontSize="";
		banner.children[0].attributes.height.value="35"; banner.children[1].style.fontSize="25px";
		hd.style.fontSize="15px";
		hd.style.marginTop='15px';
    document.getElementById("mtop").style.height='10px';
    document.body.style.fontSize='12px';
    head.style.marginBottom='5px';
    document.getElementsByTagName('table')[0].className='print print2';
		document.getElementsByClassName("container")[0].style.pageBreakAfter ='always';
		
    var newNode = document.importNode(head, true);
		var el = document.getElementById("add");
		el.appendChild(newNode);
	}
})();
</script>
{/if}
</body>
</html>
{/strip}
{*conversi dari html ke pdf: +983 (IE), 1001 (firefox) --> beda 14*}
{* firefox +14 from ie8 *}
