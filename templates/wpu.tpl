{strip}
<table class="{if $print=='pdf'}print{else}report first{/if}">
  <thead>
  <tr>
  <th rowspan="2"><div class="head">Time</div></th>
	<th colspan="6">WPU</th>
	<tr>
	<th rowspan="1"><div class="head">Tank Level<br>LT-10.1<br>(<u>></u> 100 Liter)</div></th>
	<th><div class="head">Tank Temp.<br>TE-10.1<br>(&deg;C)</div></th>
  <th><div class="head">Loop Temp.<br>TE-10.2<br>(&deg;C)</div></th>
  <th><div class="head">Loop Return Temp.<br> After Exch.<br>TE-10.5 (&deg;C)</div></th>
  <th><div class="head">Loop Cond.<br>CR10.1<br>(<u><</u> 0.80&micro;)</div> </th>
  <th><div class="head">Loop Return Pressure<br>PT-10.1<br>(<u>></u> 0.25 Bar)</div></th>
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
        <td width="100px"></td> <td width="142px"></td> <td width="142px"></td> <td width="142px"></td> 
        <td width="142px"></td> <td width="142px"></td> <td width="129px"></td> 
      </tr>
	{/if}
	{foreach $report.tdata as $data nocache}
	<tr>
		<td align="center">{$data.0}</td>
		{tdata v=$data.1 c="x >= 100" d=1}
		{tdata v=$data.2 d=1}
		{tdata v=$data.3 d=1}
		{tdata v=$data.4 d=1}
		{tdata v=$data.5 c="x <= 0.80" d=2}
		{tdata v=$data.6 c="x >= 0.25" d=2}
	</tr>
	{/foreach}
	{if !$print}</tbody></table></div>{else}</table>{/if}
{/if}
{strip}
