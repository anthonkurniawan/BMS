{strip}
<table class="{if $print=='pdf'}print{else}report first{/if}">
  <thead>
  <tr>
  <th rowspan="2"><div class="head">Time</div></th>
        <th colspan="2">R-158</th>
        <th colspan="2">R-160</th>
        <th colspan="2">R-WIP</th>
        <th colspan="2">R-312</th>
        <th>R-321</th>
        <th>R-314 WIP</th>
        <th colspan="2">R-167</th>
      </tr>
      <tr>
        <th><div class="head">Temp.<br>(<u><</u> 25 &deg;C)</div></th>
        <th><div class="head">RH (<u><</u> 40%)</div></th>
        <th><div class="head">Temp.<br>(<u><</u>25 &deg;C)</div></th>
        <th><div class="head">RH</div></th>
        <th><div class="head">Temp.<br>(<u><</u>25 &deg;C)</div></th>
        <th><div class="head">RH (<u><</u> 40%)</div> </th>
        <th><div class="head">Temp.<br>(<u><</u>25 &deg;C)</div></th>	
        <th><div class="head">RH (<u><</u> 40%)</div> </th>
        <th><div class="head">Temp.<br>(<u><</u>25 &deg;C)</div></th>
        <th><div class="head">Temp.<br>(<u><</u>25 &deg;C)</div></th>
        <th><div class="head">Temp.<br>(<u><</u>25 &deg;C)</div></th>
        <th><div class="head">RH.<br>(<u><</u>40%)</div> </th>
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
				<td width="70px"></td> <td width="82px"></td> <td width="82px"></td> <td width="82px"></td> <td width="82px"></td> <td width="82px"></td> <td width="82px"></td> <td width="82px"></td><td width="82px"></td> <td width="83px"></td> <td width="83px"></td> <td width="82px"></td><td width="82px"></td>
			</tr>
	{/if}
	{foreach $report.tdata as $data nocache}
		<tr>
			<td align="center">{$data.0}</td>
			{tdata v=$data.1 c="x <=25" d=1}
			{tdata v=$data.2 c="x <=40" d=1}
			{tdata v=$data.3 c="x <=25" d=1}
			{tdata v=$data.4 d=1}
			{tdata v=$data.5 c="x <=25" d=1}
			{tdata v=$data.6 c="x <=40" d=1}
			{tdata v=$data.7 c="x <=25" d=1}
			{tdata v=$data.8 c="x <=40" d=1}
			{tdata v=$data.9 c="x <=25" d=1}
			{tdata v=$data.10 c="x <=25" d=1}
			{tdata v=$data.12 c="x <=25" d=1}
			{tdata v=$data.11 c="x <=40" d=1}
		</tr>
	{/foreach}
	{if !$print}</tbody></table></div>{else}</table>{/if}
{/if}
{/strip}
