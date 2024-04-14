{strip}
<table class="{if $print=='pdf'}print{else}report first{/if}">
  <thead>
  <tr>
  <th rowspan="2"><div class="head">Time</div></th>
	<th colspan="7"> Staging & Quarantine </th>
	</tr>
	<tr>
		<th><div class="head">X1<br>Temp. (<u><</u> 30&deg;C)</div> </th>
		<th><div class="head">X2<br>Temp. (<u><</u> 30&deg;C)</div> </th>
		<th><div class="head">X3<br>Temp. (<u><</u> 30&deg;C)</div> </th>
		<th><div class="head">X4<br>Temp. (<u><</u> 30&deg;C)</div> </th>
		<th><div class="head">X5<br>Temp. (<u><</u> 30&deg;C)</div> </th>
		<th><div class="head">X6<br>Temp. (<u><</u> 30&deg;C)</div> </th>
		<th><div class="head">X7<br>Temp. (<u><</u> 25&deg;C)</div> </th>
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
        <td width="125px"></td> <td width="125px"></td> <td width="125px"></td> <td width="125px"></td> <td width="125px"></td> <td width="125px"></td> <td width="125px"></td> <td width="125px"></td>{*1000*}
      </tr>
	{/if}
	{foreach $report.tdata as $data nocache}
	<tr>
		<td align="center">{$data.0}</td>
		{tdata v=$data.1 c="x <= 30" d=1}
		{tdata v=$data.2 c="x <= 30" d=1}
		{tdata v=$data.3 c="x <= 30" d=1}
		{tdata v=$data.4 c="x <= 30" d=1}
		{tdata v=$data.5 c="x <= 30" d=1}
		{tdata v=$data.6 c="x <= 30" d=1}
		{tdata v=$data.7 c="x <= 25" d=1}
	</tr>
	{/foreach}
	{if !$print}</tbody></table></div>{else}</table>{/if}
{/if}
{/strip}
