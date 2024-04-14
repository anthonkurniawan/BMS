{strip}
<table class="{if $print=='pdf'}print{else}report first{/if}">
  <thead>
  <tr>
  <th rowspan="2"><div class="head">Time</div></th>
	<th colspan="7">RM / PM</th>
	<th rowspan="2"><div class="head">Flammable <br> Temp.<br>(<u><</u> 25 &deg;C)</div></th>
	<th colspan="2">R-133 <br>Pharmacy Weighing</th>
	<th colspan="2">R-328 <br>Dispensing Booth</th>
	</tr>
	<tr>
	<th><div class="head">X1 Temp.</div></th>
	<th><div class="head">X2 Temp.</div></th>
	<th><div class="head">X3 Temp.<br>(<u><</u> 30&deg;C)</div></th>
	<th><div class="head">X4 Temp.</div></th>
	<th><div class="head">X5 Temp.<br>(<u><</u> 25&deg;C)</div></th>
	<th><div class="head">X6 Temp.</div></th>
	<th><div class="head">Cold Box Temp.<br>(3-7&deg;C)</div></b></th>
	<th><div class="head">Temp. (<u><</u> 25&deg;C)</div></th>
	<th><div class="head">RH. (<u><</u> 65%)</div></th>
	<th><div class="head">Temp. (<u><</u> 25&deg;C)</div></th>
	<th><div class="head">RH. </div></th>
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
        <td width="75px"></td> <td width="80px"></td> <td width="80px"></td> <td width="80px"></td> <td width="80px"></td> <td width="80px"></td> <td width="80px"></td> <td width="80px">
        </td><td width="100px"></td><td width="90px"></td> <td width="90px"></td> <td width="90px"></td> <td width="60px"></td>
      </tr>
	{/if}
	{foreach $report.tdata as $data nocache}
	<tr>
		<td align="center">{$data.0}</td>
		{tdata v=$data.1 d=1}
		{tdata v=$data.2 d=1}
		{tdata v=$data.3 c="x <=30" d=1}
		{tdata v=$data.4 d=1}
		{tdata v=$data.5 d=1 c="x <= 25"}
		{tdata v=$data.6 d=1}
		{tdata v=$data.7 c="x >=3 && x <=7" d=1}
		{tdata v=$data.8 d=1 c="x <= 25"}
		{tdata v=$data.9 d=1 c="x <= 25"}
		{tdata v=$data.10 d=1 c="x <= 65"}
		{tdata v=$data.11 d=1 c="x <= 25"}
		{tdata v=$data.12 d=1}
	</tr>
	{/foreach}
	{if !$print}</tbody></table></div>{else}</table>{/if}
{/if}
{/strip}
