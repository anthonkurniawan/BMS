==> {$unit.file}
{strip}
<table class="{if $print=='pdf'}print{else}report first{/if}">
  <thead>
  <tr>
  <th rowspan="2"><div class="head">Time</div></th>
	<th colspan="2">Room 140</th>
	<th colspan="13">Differential Pressure Sterile Area</th>
	</tr>
	<tr>
	<th><div class="head">Temp<br>16-25&deg;C</div></th>
	<th><div class="head">RH<br><u><</u> 63%</div> </th>

	<th><div class="head">R.125 - R.110<br><U>></U> 10 Pa</div></th>
	<th><div class="head">R.126 - R.110<br><U>></U> 10 Pa</div></th>
	<th><div class="head">R.127 - R.110<br><U>></U> 10 Pa</div></th>
	<th><div class="head">R.128 - R.110<br><U>></U> 10 Pa</div></th>
	<th><div class="head">R.140 - R.110<br><U>></U> 10 Pa</div></th>
	<th><div class="head">R.141 - R.110<br><U>></U> 10 Pa</div></th>
	<th><div class="head">R.145 - R.110<br><U>></U> 10 Pa</div></th>
	<th><div class="head">R.129 - R-148<br><U>></U> 10 Pa</div></th>
	<th><div class="head">R.140 - R-126<br><U>></U> 5 Pa</div></th>
	<th><div class="head">R.141 - R-126<br><U>></U> 5 Pa</div></th>

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
        <td width="80px"></td> <td width="80px"></td> <td width="80px"></td> <td width="80px"></td><td width="80px"></td> <td width="80px"></td> <td width="80px"></td> <td width="80px"></td><td width="80px"></td> <td width="80px"></td> <td width="80px"></td> <td width="80px"></td> <td width="80px"></td>
      </tr>
	{/if}
	{foreach $report.tdata as $data nocache}
	<tr>
		<td align="center">{$data.0}</td>
		{tdata v=$data.1 c="x >=16 && x <=25" d=1}
		{tdata v=$data.2 c="x <=63" d=1}
		{tdata v=$data.3 c="x >= 10" d=1}
		{tdata v=$data.4 c="x >= 10" d=1}
		{tdata v=$data.5 c="x >= 10" d=1}
		{tdata v=$data.6 c="x >= 10" d=1}
		{tdata v=$data.7 c="x >= 10" d=1}
		{tdata v=$data.8 c="x >= 10" d=1}
		{tdata v=$data.9 c="x >= 10" d=1}
		{tdata v=$data.10 c="x >= 10" d=1}
		{*tdata v=$data.11 c="x >= 10" d=1*}
		{*tdata v=$data.12 c="x >= 10" d=1*}
		{*tdata v=$data.13 c="x >= 10" d=1*}
		{tdata v=$data.14 c="x >= 5" d=1}
		{tdata v=$data.15 c="x >= 5" d=1}
	</tr>
	{/foreach}
	{if !$print}</tbody></table></div>{else}</table>{/if}
{/if}
{/strip}
