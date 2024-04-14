{strip}
<table class="{if $print=='pdf'}print{else}report first{/if}">
  <thead>
		<tr>
			<th rowspan="2"><div class="head">Time</div></th>
			<th colspan="2">R-259</th>
			<th colspan="1">L-210</th>
			<th colspan="2">L-259</th>
			<th colspan="1">R-257</th>
			<th colspan="1">R-256</th>
			<th colspan="1">L-257</th>
		</tr>
		<tr>
			<th><div class="head">RH</div></th>
			<th><div class="head">Temp.<br> (20-25&deg;C)</div></th>
			<th><div class="head">Incubator<br>Temp. (20-25&deg;C)</div></th>
			<th><div class="head">Cold Chamber <br>Temp. (2-8&deg;C)</div></th>
			<th><div class="head">Incubator <br>Temp. (20-25&deg;C)</div></th>
			<th><div class="head">Temp.<br> (20-25&deg;C)</div></th>
			<th><div class="head">Temp.<br> (20-25&deg;C)</div></th>
			<th><div class="head">Cold Chamber<br>Temp. (2-8&deg;C)</div></th>
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
        <td width="70px"></td> <td width="100px"></td> <td width="100px"></td> <td width="100px"></td> <td width="100px"></td> <td width="100px"></td> <td width="100px"></td> <td width="100px"></td> <td width="90px"></td> 
      </tr>
	{/if}
	{foreach $report.tdata as $data nocache}
	<tr>
		<td align="center">{$data.0}</td>
		{tdata v=$data.1 d=1}
    {tdata v=$data.2 c="x >= 20 && x <=25" d=1}
    {tdata v=$data.3 c="x >= 20 && x <=25" d=1}
    {tdata v=$data.4 c="x >= 2 && x <=8" d=1}
    {tdata v=$data.5 c="x >= 20 && x <=25" d=1}
    {tdata v=$data.6 c="x >= 20 && x <=25" d=1}
    {tdata v=$data.7 c="x >= 20 && x <=25" d=1}
    {tdata v=$data.8 c="x >= 2 && x <=8" d=1}
	</tr>
	{/foreach}
	{if !$print}</tbody></table></div>{else}</table>{/if}
{/if}
{/strip}
