{strip}
<table class="{if $print=='pdf'}print{else}report first{/if}">
  <thead>
  <tr>
		<th rowspan="2"><div class="head">Time</div></th>
    <th>Sand</th>
    <th colspan="2">Line-A</th>
    <th colspan="2">Line-B</th>
    <th>RO-DEMIN</th>
  </tr>
  <tr>
    <th><div class="head">Filtered Cond.<br>(&micro;s)</div></th>
    <th><div class="head">CC/CA Cond.<br>(&micro;s)</div></th>
    <th><div class="head">Mixbed Cond.<br>(&micro;s)</div></th>
    <th><div class="head">CC/CA Cond.<br>(&micro;s)</div></th>
    <th><div class="head">Mixbed Cond.<br>(&micro;s)</div></th>
    <th><div class="head">Water TOC<br>(<u><</u>500 ppb)</div></th>
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
        <td width="100px"></td> <td width="157px"></td> <td width="157px"></td> <td width="157px"></td> <td width="157px"></td> <td width="157px"></td> <td width="157px"></td> 
      </tr>
	{/if}
	{foreach $report.tdata as $data nocache}
		<tr>
			<td align="center">{$data.0}</td>
			{tdata v=$data.1 d=1}
			{tdata v=$data.2 d=2}
			{tdata v=$data.4 d=2}
			{tdata v=$data.3 d=2}
			{tdata v=$data.5 d=2}
			{tdata v=$data.6 c="x <= 500" d=1}
		</tr>
	{/foreach}
	{if !$print}</tbody></table></div>{else}</table>{/if}
{/if}
{/strip}
