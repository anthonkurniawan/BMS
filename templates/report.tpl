{strip}
{if !$q.print}
<style>
table.report tr.filter td{ padding:0px }table.report tr.filter td:first-child{ width:75px}table.report tr:not(.filter) td:first-child{ font-weight: bold;}
#ds,#de{ height:16px}
</style>
<!--<script type="text/javascript">
$( document ).ready(function(){
	$('select[name="q[dept]"]').change(function(){ {*console.log(this.value);*}
		bms.ajaxCall('api.php?q=units&dept='+this.value, 'json', null, function(rs){
			bms.buildSelect(rs,'select[name="q[unit]"]','All');
		});
	});
});
</script>
-->
<div class="judul left">
	<i class="fa fa-lg fa-list-alt"></i><b>{if $q.dept}{dept d=$q.dept}{else}All{/if} Area Report</b> <span class="disabled">{if $data.count}{$data.count}{else}0{/if} records found</span>
</div>

{else}
 <h5>{if $q.dept}{dept d=$q.dept}{else}All{/if} Area Report</h5>
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
			<thead>
			<tr><th rowspan="2">Date</th><th rowspan="2">Department</th><th rowspan="2">Unit</th><th rowspan="2">Status</th><th colspan="2">Initiator</th><th colspan="2">Initiator Spv</th><th colspan="2">Engineering Spv</th><th colspan="2">QA Spv</th><th rowspan="2">Progress</th></tr>
			<tr><th>Submit By</th><th>Submit Date</th><th>Submit By</th><th>Submit Date</th><th>Submit By</th><th>Submit Date</th><th>Submit By</th><th>Submit Date</th></tr>
			</thead>
			<tbody>
			{if !$q.print}
			<tr class="filter">
				<td><input type="text" id="dt" name="q[dt]" value="{$q.dt|date_format:"%d-%b-%Y"}"></td>
				<td>
					<select name="q[dept]" {if $q.selectDeptDis}disabled="disabled"{/if}>
						<option value='all' {if $q.deptSelected=='all'}selected{/if}>All</option>
						{html_options options=$q.depts selected=$q.deptSelected}
					</select>
				</td> 
				<td>
					<select name="q[unit]">
						<option value='' {if $q.unit==''}selected{/if}>All</option>
						{html_options options=$q.units selected=$q.unit}
					</select>
				</td> 
				<td>
					<select id="st" name="q[st]">
						<option value='' {if $q.st==''}selected{/if}>All</option>
						<option value=2 {if $q.st==2}selected{/if}>Deviasi</option>
						<option value=1 {if $q.st==1}selected{/if}>No Deviasi</option>
					</select>
				</td> 
				{*
				<td><input type='text' name='q[submit_int]'></td> <td><input type='text' name='q[submit_int_dt]'></td> <td><input type='text' name='x'></td>
				<td><input type='text' name='x'></td> <td><input type='text' name='x'></td> <td><input type='text' name='x'></td> <td><input type='text' name='x'></td> <td><input type='text' name='x'></td>
				*}
				<td colspan="8"></td>
				<td>
					<button type="submit" class="btn btn-sm btn-default" onclick="bms.qreport(null,false, event);"><span class="ui-icon ui-icon-search"></span>Find</button>
					<button class="btn btn-sm btn-default" type="reset">Reset</button>
				</td>
			</tr>
			{/if}
			{if $data.report}
			{foreach $data.report as $r nocache}
			{if is_string($r.comment)}<tr class="broken">{else}<tr>{/if}	
				<td align="center"> 
					{if $q.print} {$r.date|date_format:"%d-%m-%Y"} {else} {*->{$r.id}*}
					<a href="{$r.link}">{if {activeUser p=$r.progress}}<b class="txtErr">{$r.date|date_format:"%d-%m-%Y"}</b> {else} {$r.date|date_format:"%d-%m-%Y"} {/if}</a>{/if}
				</td>
				<td>{dept d=$r.dept}</td>
				<td title="{unitLabel u=$r.unit key=unit_lbl}" width="100">{unitLabel u=$r.unit key=unit_lbl}</td>
				<td>{status stat=$r.status}</td>
				{*<!-- CHECK IF COMMENT IS EXIST -->*}
				{if is_string($r.comment)}
				<td colspan="8" align="center">{$r.comment}</td>
				{else}
					<td>{if $r.progress==0}<span class='isPending' title="pending"></span>{/if} <span class="left">{$r.comment.int.username}</span></td>
					<td align="center">{$r.comment.int.submit_date|date_format:"%d-%m-%Y"}</td>
					{if $r.dept!='eng' && $r.dept!='qa'}
						{if $r.comment.spv_int}
							<td>{if $r.comment.spv_int.isReject}<span class='isReject' title="rejected"></span>{else}<span class='isApprove' title="approved"></span>{/if} <span class="left">{$r.comment.spv_int.username}</span></td>
							<td align="center">{$r.comment.spv_int.submit_date|date_format:"%d-%m-%Y"}</td>
						{else}
							<td colspan='2' align="center"> {if $r.progress==1}<span class='isPending' title="pending"></span><span style="margin-right:19px">-</span>{else}-{/if}</td>
						{/if}
					{else}
						<td colspan='2' align='center'><i>-n/a-</i></td>
					{/if}

					{if $r.comment.spv_eng}
						<td>{if $r.comment.spv_eng.isReject}<span class='isReject' title="rejected"></span>{else}<span class='isApprove' title="approved"></span>{/if} <span class="left">{$r.comment.spv_eng.username}</span></td>
						<td align="center">{$r.comment.spv_eng.submit_date|date_format:"%d-%m-%Y"}</td>
					{else}
						<td colspan='2' align="center"> {if $r.progress==2}<span class='isPending' title="pending"></span><span style="margin-right:19px">-</span>{else}-{/if}</td>
					{/if}

					{if $r.comment.spv_qa}
						<td>{if $r.comment.spv_qa.isReject}<span class='isReject' title="rejected"></span>{else}<span class='isApprove' title="approved"></span>{/if} <span class="left">{$r.comment.spv_qa.username}</span></td>
						<td align="center">{$r.comment.spv_qa.submit_date|date_format:"%d-%m-%Y"}</td>
					{else}
						<td colspan='2' align="center"> {if $r.progress==3}<span class='isPending' title="pending"></span><span style="margin-right:19px">-</span>{else}-{/if}</td>
					{/if}
				{/if}
				<td>{if $r.progress==1} <b class="textNormal">Initiated</b> {elseif $r.progress==4}<b class="textNormal">Complete</b> {else} <b class="textNormal">In Progress</b>{/if}</td>
			</tr>
			{/foreach}
			{else}
			<tr><td colspan="13" height="400px">{$data.msg}</td></tr>
			{/if}
			</tbody>
		</table>
	</div>
</form>	

{if $data.report && !$q.print}
<div class="ui-helper-clearfix panel-btm">
	<div class="pager left">{$data.pages}</div> 
	<div class="pager-nav left">{$data.pager}</div>
  <span class="right btn btn-xs btn-primary print" onclick="bms.qreport(null,1,event)"><i class="fa fa-file-excel-o"></i>export</span>
</div>
{*
<div style="border:1px solid red">
	QUERY dept_r : {$q.r} dept : {$q.dept} status : {$q.st} date: {$q.dt} date_s : {$q.ds} date_e : {$q.de} <br>page : {$q.page} position : {$q.pos} <br>
</div>
*}
{/if}
{/strip}
