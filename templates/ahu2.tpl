{strip}
<table class="{if $print=='pdf'}print{else}report first{/if}">
  <thead>
  <tr>
		<th rowspan="2"><div class="head">Time</div></th>
		<th colspan="2"> AHU 24.1 </th>
		<th colspan="3"> AHU 24.2 </th>
		<th colspan="2"> AHU 25 </th>
		<th colspan="2"> AHU 28 </th>
	</tr>
	<tr>
		<th> <div class="head">Supply Temp.<br>(&deg;C)</div> </th>
		<th><div class="head">Min Air Flow<br>3000 CFM aktual<br>(<u>></u> 3000)</div></th>
		<th> <div class="head">Supply Temp. <br>(&deg;C)</div> </th>
		<th> <div class="head">Supply RH</div> </th>
		<th><div class="head">Min Air Flow<br>5400 CFM aktual<br>(<u>></u> 5400)</div></th>
		<th> <div class="head">Supply Temp. <br>(&deg;C)</div></th>
		<th><div class="head">Min Air Flow<br>2800 CFM aktual<br>(<u>></u> 2800)</div></th>
		<th> <div class="head">Supply Temp. <br>(&deg;C)</div> </th>
		<th><div class="head">Min Air Flow<br>5500 CFM aktual<br>(<u>></u> 5500)</div></th>
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
				<td width="70px"></td> <td width="80px"></td> <td width="120px"></td> <td width="80px"></td> <td width="80px"></td> <td width="120px"></td>
				<td width="80px"></td> <td width="120px"></td><td width="80px"></td> <td width="120px"></td>
			</tr>
	{/if}
	{foreach $report.tdata as $data nocache}
		<tr>
			<td align="center">{$data.0}</td>
			{tdata v=$data.1}
			{tdata v=$data.2 c="x >= 3000"}
			{tdata v=$data.3}
			{tdata v=$data.4}
			{tdata v=$data.5 c="x >= 5400"}
			{tdata v=$data.6}
			{tdata v=$data.7 c="x >= 2800"}
			{tdata v=$data.8}
			{tdata v=$data.9 c="x >= 5500"}
		</tr>
	{/foreach}
	{if !$print}</tbody></table></div>{else}</table>{/if}
{/if}
{/strip}
