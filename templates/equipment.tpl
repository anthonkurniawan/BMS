{strip}
<table class="{if $print=='pdf'}print{else}report first{/if}">
  <thead>
  <tr>
  <th><div class="head">Time</div></th>
	<th><div class="head">Refrigerator 1</br>Temp.&deg;C</div></th>
	<th><div class="head">Refrigerator 2</br>Temp.&deg;C</div></th>
	<th><div class="head">Refrigerator 3</br>Temp.&deg;C</div></th>
	<th><div class="head">Refrigerator 4</br>Temp.&deg;C</div></th>
	<th><div class="head">Refrigerator 5</br>Temp.&deg;C</div></th>
	<th><div class="head">Incubator 1</br>Temp.&deg;C</div></th>
	<th><div class="head">Incubator 2</br>Temp.&deg;C</div></th>
	<th><div class="head">Incubator 3</br>Temp.&deg;C</div></th>
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
        <td width="126px"></td> <td width="120px"></td> <td width="120px"></td> <td width="120px"></td> <td width="120px"></td> <td width="120px"></td> <td width="120px"></td> <td width="120px"></td><td width="120px"></td> {*1086*}
     </tr>
	{/if}
	{foreach $report.tdata as $data nocache}
	<tr>
		<td align="center">{$data.0}</td>
    {tdata v=$data.1}
    {tdata v=$data.2}
    {tdata v=$data.3}
    {tdata v=$data.4}
    {tdata v=$data.5}
    {tdata v=$data.6}
    {tdata v=$data.7}
    {tdata v=$data.8}
	</tr>
	{/foreach}
	{if !$print}</tbody></table></div>{else}</table>{/if}
{/if}
{/strip}
