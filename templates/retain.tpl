{strip}
<table class="{if $print=='pdf'}print{else}report first{/if}">
  <thead>
  <tr>
  <th rowspan="2"><div class="head">Time</div></th>
	<th colspan="3">Temperature retained Sample Room</th>
	<th colspan="3">Dispensing Booth</th>
	</tr>
	<tr>
	<th><div class="head">182-A (<u><</u> 25 &deg;C)</div></th>
	<th><div class="head">183-A (<u><</u> 30 &deg;C)</div></th>
	<th><div class="head">183-B (<u><</u> 30 &deg;C)</div></th>
	<th><div class="head">System Flow </br>(360-420pa)</div></th>
	<th><div class="head">&Delta;P  R-Sampling</br>Booth –Mat. Air Lock (<u>> </u>5 pa)</div></th>
	<th><div class="head">&Delta;P  R-Sampling</br>Booth – Gowning (<u>> </u>5 pa)</div></th>
	</tr>
	</thead>
{if !$print || $report.tdata.error}
</table>
{/if}

{if $report.tdata.error}
	<div class="tag-error">{$report.tdata.error}</div>
{else}
	{if !$print}
	<div id="table_div">
		<table class="report">
			<tbody>
			<tr id="firstTr">
        <td width="100px"></td> <td width="130px"></td> <td width="130px"></td> <td width="130px"></td> <td width="130px"></td> <td width="160px"></td> <td width="146px"></td> 
      </tr>
	{/if}
	{foreach $report.tdata as $data nocache}
	<tr>
		<td align="center">{$data.0}</td>
		{tdata v=$data.1 c="x <= 25" d=1}
		{tdata v=$data.2 c="x <= 30" d=1}
		{tdata v=$data.3 c="x <= 30" d=1}
		{tdata v=$data.4 c="x >= 360 && x <= 420" d=1}
		{tdata v=$data.5 c="x >= 5" d=1}
		{tdata v=$data.6 c="x >= 5" d=1}
	</tr>
	{/foreach}
	{if !$print}</tbody></table></div>{else}</table>{/if}
{/if}
{strip}
