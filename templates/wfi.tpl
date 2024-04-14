{strip}
<table class="{if $print=='pdf'}print{else}report first{/if}">
  <thead>
  <tr>
  <th rowspan="2"><div class="head">Time</div></th>
	<th colspan="5">WFI</th>
	<th colspan="2">Pure Steam Cond.</th>
	</tr>
	<tr>
	<!--<th><div class="head">Prod. Temp.<br>TE-012<br>(&deg;C)</div></th>-->
	<th><div class="head">Tank Level<br>LE-015.1<br>(<u>></u> 100 liter)</div></th>
	<th><div class="head">Tank Temp.<br>TE-015.1<br>(<u>></u> 70 &deg;C)</div></th>
	<th><div class="head">Return Loop Temp.<br>TE-015.4<br>(<u>></u> 70 &deg;C)</div></th>
	<th><div class="head">Return Loop Temp.<br>After Exch. TE-015.5<br>(<u>></u> 70 &deg;C)</div></th>
	<!--<th><div class="head">Prod. Cond.<br>CR-012<br>(&micro;s)</div></th>-->
	<th><div class="head">Return Loop Cond.<br> CR-015<br>(<u><</u> 0.50 &micro;s)</div></th>
	<th><div class="head">CR-020<br>(<u><</u> 0.80 &micro;s)</div></th>
	<th><div class="head">PT-020<br>(<u>></u> 0.5 Bar)</div></th>
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
        <td width="85px"></td> <td width="100px"></td> <td width="100px"></td> <td width="110px"></td> <td width="110px"></td> <td width="120px"></td><td width="90px"></td> <td width="78px"></td>
      </tr>
	{/if}
	{foreach $report.tdata as $data nocache}
	<tr>
		<td align="center">{$data.0}</td>
		{*tdata v=$data.1*}
		{tdata v=$data.2 c="x >= 100" d=1}
		{tdata v=$data.3 c="x >= 70" d=1}
		{tdata v=$data.4 c="x >= 70" d=1}
		{tdata v=$data.5 c="x >= 70" d=1}
		{*tdata v=$data.6*}
		{tdata v=$data.7 c="x <= 0.50" d=2}
		{tdata v=$data.8 c="x <= 0.80" d=2}
		{tdata v=$data.9 c="x >= 0.5" d=1}
	</tr>
	{/foreach}
	{if !$print}</tbody></table></div>{else}</table>{/if}
{/if}
{/strip}
