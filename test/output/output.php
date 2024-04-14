<html><head><link href='../css/style.css' rel='stylesheet' type=text/css></link></head><body>
<table class="report first"><thead><tr><th rowspan="2"><div class="head">Time</div></th><th colspan="2" rowspan="1">e[{"head":"e","tagname":"ACS1.AHU14A_SUPPLYAIR.F_CV","label":"Supply Temp","spec":">25","class":"head"},{"head":"e","tagname":"ACS1.AHU94_HUMIDITY.F_CV","label":"Supply<br>RH","spec":">25","class":"head"}]</th><th colspan="2" rowspan="1">A[{"head":"A","tagname":"ACS1.AHU14A_FLOW.F_CV","label":"Min Air Flow<br>3000 CFM<br>aktual","spec":">25","class":"head"},{"head":"A","tagname":"ACS1.AHU14B_FLOW.F_CV","label":"Min Air Flow<br>3000 CFM<br>aktual","spec":">25","class":"head"}]</th><th colspan="1" rowspan="1">B[{"head":"B","tagname":"ACS1.AHU14B_SUPPLYAIR.F_CV","label":"Supply Temp.","spec":">25","class":"head"}]</th><th colspan="3" rowspan="1">C[{"head":"C","tagname":"ACS1.AHU14B_HUMIDITY.F_CV","label":"Supply RH","spec":">25","class":"head"},{"head":"C","tagname":"ACS1.AHU16_FLOW.F_CV","label":"Min Air Flow<br>3000 CFM<br>aktual","spec":">25","class":"head"},{"head":"C","tagname":"ACS1.AHU94_FLOW.F_CV","label":"Min Air Flow<br>3000 CFM<br>aktual","spec":">25","class":"head"}]</th><th colspan="1" rowspan="1">D[{"head":"D","tagname":"ACS1.AHU16_SUPPLYAIR.F_CV","label":"Supply CC Temp.","spec":">25","class":"head"}]</th><th colspan="1" rowspan="2"><div class='head'>Supply RH <br><small>ACS1.AHU16_HUMIDITY.F_CV<br>(>25)</small></div></th><th colspan="1" rowspan="2"><div class='head'>Supply Temp.<br><small>ACS1.AHU17_SUPPLYAIR.F_CV<br>(>25)</small></div></th><th colspan="1" rowspan="1"> [{"head":" ","tagname":"ACS1.AHU94_SUPPLYAIR.F_CV","label":"Supply Temp.","spec":">25","class":"head"}]</th></tr><tr><th><div class='head'>Supply Temp<br><small>ACS1.AHU14A_SUPPLYAIR.F_CV<br>(>25)</small></th><th><div class='head'>Supply<br>RH<br><small>ACS1.AHU94_HUMIDITY.F_CV<br>(>25)</small></th><th><div class='head'>Min Air Flow<br>3000 CFM<br>aktual<br><small>ACS1.AHU14A_FLOW.F_CV<br>(>25)</small></th><th><div class='head'>Min Air Flow<br>3000 CFM<br>aktual<br><small>ACS1.AHU14B_FLOW.F_CV<br>(>25)</small></th><th><div class='head'>Supply Temp.<br><small>ACS1.AHU14B_SUPPLYAIR.F_CV<br>(>25)</small></th><th><div class='head'>Supply RH<br><small>ACS1.AHU14B_HUMIDITY.F_CV<br>(>25)</small></th><th><div class='head'>Min Air Flow<br>3000 CFM<br>aktual<br><small>ACS1.AHU16_FLOW.F_CV<br>(>25)</small></th><th><div class='head'>Min Air Flow<br>3000 CFM<br>aktual<br><small>ACS1.AHU94_FLOW.F_CV<br>(>25)</small></th><th><div class='head'>Supply CC Temp.<br><small>ACS1.AHU16_SUPPLYAIR.F_CV<br>(>25)</small></th><th><div class='head'>Supply Temp.<br><small>ACS1.AHU94_SUPPLYAIR.F_CV<br>(>25)</small></th></tr></thead>
{if !$print || $report.tdata.error}</table>{/if}
{if $report.tdata.error}<div class="tag-error">{$report.tdata.error}</div>
{else}
	{if !$print}<div id="table_div">
		<table class="report"><tbody>
		<tr id="firstTr"><td width='75px'></td><td width='75px'></td><td width='75px'></td><td width='75px'></td><td width='75px'></td><td width='75px'></td><td width='75px'></td><td width='75px'></td><td width='75px'></td><td width='75px'></td><td width='75px'></td><td width='75px'></td><td width='75px'></td></tr>
	{/if}
	{$tdata}<!--foreach tdata nanti pindah from tpl ke php aja-->
	{if !$print}</tbody></table></div>{else}</table>{/if}
{/if}