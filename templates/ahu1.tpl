{strip}

<!--TEST INTERVAL VALUE-->
<style>
#data-intv div { width:100px;margin-right:3px; float:left; border:1px solid black }
</style>

<div id="data-intv">
  <div id="d_intv">1</div>
  <div id="d_val">2</div>
</div>
<!-- END -->

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
		<th><div class="head">Supply Temp. (&deg;C)</div></th>
		<th><div class="head">Min Air Flow<br>3000 CFM aktual<br>(<u>></u> 3000)</div></th>
		<th><div class="head">Supply Temp. (&deg;C)</div></th>
		<th><div class="head">Supply RH</div></th>
		<th><div class="head">Min Air Flow<br>5400 CFM aktual<br>(<u>></u> 5400)</div></th>
		<th><div class="head">Supply Temp. (&deg;C)</div></th>
		<th><div class="head">Supply RH </div></th>
		<th><div class="head">Min Air Flow<br>2800 CFM aktual<br>(<u>></u> 2800)</div></th>
		<th><div class="head">Supply Temp. (&deg;C)</div></th>
		<th><div class="head">Supply Temp. (&deg;C)</div></th>
		<th><div class="head">Supply<br>RH</div></th>
		<th><div class="head">Min Air Flow<br>5500 CFM aktual<br>(<u>></u> 5500)</div></th>
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
				<td width="70px"></td> <td width="70px"></td> <td width="120px"></td> <td width="70px"></td> <td width="70px"></td> <td width="120px"></td> <td width="70px"></td> <td width="70px"></td>
				<td width="120px"></td> <td width="70px"></td> <td width="70px"></td> <td width="70px"></td> <td width="120px"></td>
			</tr>
	{/if}
	{foreach $report.tdata as $k=>$data nocache}
		<tr>
			<td align="center">{$data.0}</td>
			{tdata v=$data.1}
			{tdata v=$data.2 c="x >= 3000"}
			{tdata v=$data.3}
			{tdata v=$data.4}
			{tdata v=$data.5 c="x >= 5400"}
			{tdata v=$data.6}
			{tdata v=$data.7}
			{tdata v=$data.8 c="x >= 2800"}
			{tdata v=$data.9}
			{tdata v=$data.10}
			{tdata v=$data.11}
			{tdata v=$data.12 c="x >= 5500"}
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
<!--
Dear Pak Anton
Pak, mohon bantuannya untuk revise pembulatan angka di conductivity kolom berikut yang tadinya satu angka jadi dua angka:
1.       WFI &PSG
Return Loop Cond. CR-015 (< 0.50 µs)
CR-020 (< 0.80 µs)
 
2.       WPU
Loop Cond.CR10.1 (< 0.80µ)
 
3.       Demineralisation
Line-A CC/CA Cond.(µs)
Line-B CC/CA Cond.(µs)
Line-A Mixbed Cond.(µs)
Line-B Mixbed Cond.(µs)
-->
