{strip}
{if !$q.print}
<style>.filter .btn{ width:auto}</style>
<div class="judul left">
	<i class="fa fa-lg fa-list"></i><b>User Logs {$q.uname}</b>
	<span class="disabled">{if $data.count} {$data.count} {else}0{/if} records found</span>
</div>
{else}
<!DOCTYPE html><html lang="en"><head><title>User Logsss {$q.uname}</title><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta charset="UTF-8">
<style>
body{ margin:0px; padding:0; font-size:12px }
table{ width:100%;border-spacing:0px;text-align:left;background-color:white;}
table.report tr th{ border-top: 1px solid;border-bottom: 1px solid;background:#C3DEE4;text-align:center;padding:4px } 
table.report tr td{ border-bottom:1px solid;padding:2px;}
</style>
</head>
<body>
 <strong style="font-size:14px">User Logs {$q.uname}</strong>
{/if}

{if !$q.print}  
<form method="post">
	<input name="r_page" type="hidden" id="q_page" value={$q.page}>
	<input name="print" type="hidden" id="q_print">
	<div class="right" style="margin-bottom:4px"> 
		<label for="ds">From</label>
		<input type="text" id="ds" name="q[ds]" value="{$q.ds|date_format:"%d-%b-%Y"}" size="10">
		<label for="de">to</label>
		<input type="text" id="de" name="q[de]" value="{$q.de|date_format:"%d-%b-%Y"}" size="10">
	</div>
	<div class="clear"></div>
{/if}	

<div class="box-bdr">
	<table class="report">
		<thead><tr>{if $q.print} <th>No.</th>{/if} <th>Date</th><th>Username</th><th>Department</th><th>Event</th></tr></thead>
		<tbody>
			{if !$q.print}
				<tr class="filter">
					<td><input type="text" id="dt" name="q[dt]" value="{$q.dt|date_format:"%d-%b-%Y"}"></td>
					<td><input type="text" name="q[uname]" value="{$q.uname}"></td>
					<td>
						<select name="q[dept]">
							<option value='' {if $q.dept==''}selected{/if}>All</option>
							{html_options options=$q.depts selected=$q.dept}
						</select>
					</td>
					<td width="70%">
						<input type="text" name="q[event]" value="{$q.event}" style="width:80%;float:left;">
						<button type="submit" class="btn btn-sm btn-default" onclick="bms.qreport(null,false,event)" style="width:18%;"><span class="ui-icon ui-icon-search"></span>Find</button>
						<button class="btn btn-sm btn-default" type="reset" style="width:18%;">Reset</button>
					</td>
				</tr>
			{/if}
      {if $data.users}
			{foreach $data.users as $u name=log}
			<tr>
			  {if $q.print}<td width="20">{$smarty.foreach.log.index+1}</td>{/if}
				<td align="center" {if $q.print} nowrap{/if}>{$u.date|date_format:"%d-%b-%Y %H:%M"}</td>
				<td>{$u.username}</td>
				<td>{dept d=$u.dept}</td>
				<td>{$u.event}</td>
			</tr>
			{/foreach}
			{else}
			<tr><td colspan="4" height="400px">{$data.msg}</td></tr>
			{/if}
		</tbody>
	</table>
</div>
</form>

{if $data.users && !$q.print}
<div class="ui-helper-clearfix panel-btm">
	<div class="pager left">{$data.pages}</div> 
	<div class="pager-nav left">{$data.pager}</div>
  <span class="right print btn btn-xs btn-primary" onclick="bms.qreport(null,1,event);"><i class="fa fa-file-excel-o"></i>export</span>
</div>
{else}
</body> </html>
{/if}
{/strip}
