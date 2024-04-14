{strip}
<table class="{if $print=='pdf'}print{else}report first{/if}">
  <thead>
  <tr>
		<th rowspan="2"><div class="head">Time</div></th>
		<th colspan="2">Room 404</th>
		{*<th colspan="2">Room 417</th>*}
		<th colspan="8">Differential Pressure Semi Solid Area</th>
	</tr>
	<tr>
		<th><div class="head">Temp<br><u><</u> 25&deg;C</div></th>
		<th><div class="head">RH<br><u><</u> 60%</div> </th>
		{*<th><div class="head">Temp<br><u><</u> 25&deg;C</div></th>*}
		{*<th><div class="head">RH<br>(45-55%)</div> </th>*}
		<th><div class="head">R.402 - R.108A<br><u>></u> 10Pa</div></th>
		<th><div class="head">R.411 - R.407<br><u>></u> 15Pa</div></th>
		<th><div class="head">R.143 - R.110<br><u>></u> 15Pa</div></th>
		<th><div class="head">R.416 - R.414<br><u>></u> 5Pa</div></th>
		<th><div class="head">R.417 - R.110<br><u>></u> 15Pa</div></th>
		<th><div class="head">R.418 - R.409<br><u>></u> 10Pa</div></th>
		<th><div class="head">R.400 - R.108A<br><u>></u> 10Pa</div></th>
		<th><div class="head">R.413 - R.407<br><u>></u> 10Pa</div></th>
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
        <td width="80px"></td> <td width="80px"></td><td width="80px"></td> <td width="80px"></td> <td width="80px"></td> <td width="80px"></td><td width="80px"></td> <td width="80px"></td> <td width="80px"></td> <td width="80px"></td> <td width="80px"></td>
      </tr>
	{/if}
	{foreach $report.tdata as $data nocache}
	<tr>
		<td align="center">{$data.0}</td>
		{tdata v=$data.1 c="x <=25" d=1}
		{tdata v=$data.2 c="x <=60" d=1}
		{*tdata v=$data.3 c="x <=25" d=1*}
		{*tdata v=$data.4 c="x >=45 && x <=55" d=1*}
		{tdata v=$data.5 c="x >=10" d=1}
		{tdata v=$data.6 c="x >=10" d=1}
		{tdata v=$data.7 c="x >=15" d=1}
		{tdata v=$data.8 c="x >=5" d=1}
		{tdata v=$data.9 c="x >=15" d=1}
		{tdata v=$data.10 c="x >=10" d=1}
		{tdata v=$data.14 c="x >=10" d=1}
		{tdata v=$data.15 c="x >=10" d=1}
	</tr>
	{/foreach}
	{if !$print}</tbody></table></div>{else}</table>{/if}
{/if}
{/strip}
