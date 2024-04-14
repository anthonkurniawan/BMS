{strip}

<table class="{if $print=='pdf'}print{else}report first{/if} {if $report.isDialog}dialog{/if}">
  <thead>
  <tr>
		<th rowspan="2">Time</th>
    <th colspan="9">Historian Sample</th>
  </tr>
  <tr>
    <th>Simulation00001<br>(15000 - 20000)</th>
    <th>REACTORLEVEL B_CUALM  < 267</th>
    <th>MIXOUTFLOW B_CUALM  > 267</th>
    <th>BULKFLOW B_CUALM <u><</u> 267</th>
    <th>BULKFLOW F_CV<br><u>></u> 80</th>
    <th>BULKLEVEL F_CV<br><u>></u> 1600</th>
		<th>BULKLEVEL B_CUALM</th>
		<th>CIPFLOW F_CV</th>
		<th>CIPFLOW B_CUALM</th>
  </tr>
	<tr class="sizer">
    <th class="time"></th>
		<th data-spek="x >= 15000 && x <=20000"></th>
		<th data-spek="x < 267"></th>
		<th data-spek="x>267"></th> 
		<th data-spek="x<=267"></th> 
		<th data-spek="x>=80"></th> 
		<th data-spek="x>=1600"></th>
		<th></th>
		<th></th>
		<th></th>
  </tr>
	</thead>
{if !$print || $report.error}
</table>
{/if}

{if $report.error}
	<div class="tag-error">{$report.error}</div>
{else}
	{if !$print}
	{if $report.isDialog}<div id="table_div_dialog">{else}<div id="table_div">{/if}
		<table class="report">
			<tbody>
	{/if}
	{foreach $report.data as $data nocache}
		{$t = strtotime($data.time)}
		{$time = date('H:i', $t)}
		{$time_title = date('Y-m-d H:i', $t)}
		{$class = ($time_title==$report.time_marker) ? 'time_marker' : ''}
		<tr data-time="{$report.date} {$time}" class="{$class}">
			<td class="time" title="{$time_title}">{$time}</td>
			{tdata v=$data.XP_SP3_Simulation00001 c="x >=15000 && x <=20000" d=1}
			{tdata v=$data.SAMPLE_IFIX1_BATCH_REACTORLEVEL_B_CUALM c="x < 267" d=2}
			{tdata v=$data.SAMPLE_IFIX1_BATCH_MIXOUTFLOW_B_CUALM c="x > 267" d=2}
			{tdata v=$data.SAMPLE_IFIX1_BATCH_BULKFLOW_B_CUALM c="x <= 267" d=2}
			{tdata v=$data.SAMPLE_IFIX1_BATCH_BULKFLOW_F_CV c="x >= 80" d=2}
			{tdata v=$data.SAMPLE_IFIX1_BATCH_BULKLEVEL_F_CV c="x >= 1600" d=2}
			{tdata v=$data.SAMPLE_IFIX1_BATCH_BULKLEVEL_B_CUALM d=1}
			{tdata v=$data.SAMPLE_IFIX1_BATCH_CIPFLOW_F_CV d=1}
			{tdata v=$data.SAMPLE_IFIX1_BATCH_CIPFLOW_B_CUALM d=1}
		</tr>
	{/foreach}
	{if !$print}</tbody></table></div>{else}</table>{/if}
{/if}
{/strip}

{if $report.isTrendTable}
<script type="text/javascript">
var loader=$('#loader');
$(document).ready(function(){
	$("#dialog-data").dialog( "option", "position", { my: "center top", at: "center top", of:'#content' } );
	bms.TREND_ONDIALOG = true;
});
</script>
{/if}

<!------------- TESTING -------------->
{*
<div style="text-align:left">
date: {$report.date} <br>
area: {$report.area} <br>
date: {$report.date} <br>
startTime: {$report.startTime} <br>
endTime: {$report.endTime} <br>
time_marker: {$report.time_marker} <br>
interval: {$report.interval} <br>
</div>
*}
