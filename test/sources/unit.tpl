{strip}
<table class="{if $print=='pdf'}print{else}report first{/if}">
  <thead>
  <tr>
  <th rowspan="2"><div class="head">Time</div></th>
  <th colspan="2">AHU 14A</th>
	<th colspan="3">AHU 14B</th>
	<th colspan="3">AHU 16</th>
	<th>AHU 17</th>
	<th colspan="3"> AHU 9.4</th>
	</tr>
	<tr>
		<th><div class="head">Supply Temp.</div></th>
		<th><div class="head">Min Air Flow<br>3000 CFM<br>aktual</div></th>
		<th><div class="head">Supply Temp.</div></th>
		<th><div class="head">Supply RH</div></th>
		<th><div class="head">Min Air Flow<br>3000 CFM<br>aktual</div></th>
		<th><div class="head">Supply CC Temp.</div></th>
		<th><div class="head">Supply RH </div></th>
		<th><div class="head">Min Air Flow<br>3000 CFM<br>aktual</div></th>
		<th><div class="head">Supply Temp.</div></th>
		<th><div class="head">Supply Temp.</div></th>
		<th><div class="head">Supply<br>RH</div></th>
		<th><div class="head">Min Air Flow<br>3000 CFM<br>aktual</div></th>
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
				<!--<td width="85px"></td> <td width="70px"></td> <td width="95px"></td> <td width="70px"></td> <td width="70px"></td> <td width="95px"></td> <td width="95px"></td> <td width="70px">
				</td><td width="95px"></td> <td width="70px"></td> <td width="70px"></td> <td width="70px"></td> <td width="95px"></td>-->
				<td width="90px"></td> <td width="94px"></td> <td width="94px"></td> <td width="94px"></td> <td width="94px"></td> <td width="94px"></td> <td width="94px"></td> <td width="94px"></td><td width="94px"></td> <td width="94px"></td> <td width="94px"></td> <td width="94px"></td> <td width="94px"></td>
				{* time def:90px *}
			</tr>
	{/if}
	{foreach $report.tdata as $k=>$data nocache}
		<!--<tr {if $k===0} id="firstTr" {/if}>-->
		<tr>
			<td align="center">{$data.0}</td>
			{if $data.1 !=null} <td>{$data.1|string_format:"%.1f"}</td>{else}<td class="txtErr">n/a</td>{/if}
			{if $data.2 !=null} <td>{$data.2|string_format:"%.1f"}</td>{else}<td class="txtErr">n/a</td>{/if}
			{if $data.3 !=null} <td>{$data.3|string_format:"%.1f"}</td>{else}<td class="txtErr">n/a</td>{/if}
			{if $data.4 !=null} <td>{$data.4|string_format:"%.1f"}</td>{else}<td class="txtErr">n/a</td>{/if}
			{if $data.5 !=null} <td>{$data.5|string_format:"%.1f"}</td>{else}<td class="txtErr">n/a</td>{/if}
			{if $data.6 !=null} <td>{$data.6|string_format:"%.1f"}</td>{else}<td class="txtErr">n/a</td>{/if}
			{if $data.7 !=null} <td>{$data.7|string_format:"%.1f"}</td>{else}<td class="txtErr">n/a</td>{/if}
			{if $data.8 !=null} <td>{$data.8|string_format:"%.1f"}</td>{else}<td class="txtErr">n/a</td>{/if}
			{if $data.9 !=null} <td>{$data.9|string_format:"%.1f"}</td>{else}<td class="txtErr">n/a</td>{/if}
			{if $data.10 !=null} <td>{$data.10|string_format:"%.1f"}</td>{else}<td class="txtErr">n/a</td>{/if}
			{if $data.11 !=null} <td>{$data.11|string_format:"%.1f"}</td>{else}<td class="txtErr">n/a</td>{/if}
			{if $data.12 !=null} <td>{$data.12|string_format:"%.1f"}</td>{else}<td class="txtErr">n/a</td>{/if}
		</tr>
	{/foreach}
	{if !$print}
		</tbody>
	</table>
</div>
	{else}
	</table>
	{/if}
{/if}
{strip}
