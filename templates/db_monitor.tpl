{strip}
<script src="js/Highcharts-4.2.2/js/highcharts.js"></script>
<script src="js/Highcharts-4.2.2/js/exporting.js"></script> 
<script src="js/Highcharts-4.2.2/js/highcharts-more.js"></script>
<script src="js/dbchart.js"></script>
<style>
.db-note{ margin:0px;width:30%;text-align:left;float:left}
.db-note div{ float:left}
.db-note div.a{ font-weight:bold;width:140px;clear:left}
#pie, #gauge_db, #row_max{ float:left;width:300px;height:250px}
.panel3{ padding:8px}
.box-bdr2{ margin:5px 0px 20px 0px}
tr td .fa{ color:#06c606}
tr.txtErr td .fa{ color:red}
</style>

<div class="box-bdr2">
  <div class="panel3">
    <div style="text-align:left"><i class="fa fa-database"></i>System Info</div>
  </div>

  <div class="panel-con">
    <div id="pie" style="height:300px;"></div>
    <div id="gauge_db"></div>
    <div id="row_max"></div>
    <div style="clear:both"></div>

    <div class="db-note">
      <div class="a">Total System Disk </div><div>{$data.disk.disk_mb} MBytes <small>({$data.disk.total_disk})</small></div>
      <div class="a">Disk Use </div><div>{$data.disk.used_mb} MBytes <small>({$data.disk.used_P}%) </small></div>
      <div class="a">Free System Disk </div><div>{$data.disk.free_mb} MBytes <small>({$data.disk.free_P}%)</small></div>
      <div class="a">Free </div><div>{$data.disk.total_free}</div>
    </div>
    
    <div class="db-note" style="min-width:200;width:69%">
      <div class="a">Data Base Name</div><div>{$data.dbinfo[0][0]}</div><br>
      <div class="a">Logical Name</div><div> {$data.dbinfo[0][1]}</div><br>
      <div class="a">Physical Name</div><div>{$data.dbinfo[0][2]}</div><br>
      <div class="a">Size</div><div> {$data.dbinfo[1][3]} ({$data.dbinfo[0][4]}Mb)</div><br>
      <div class="a">Max Size</div><div>{$data.dbinfo[0][5]}</div><br>
      <div class="a">Logical Name</div><div>{$data.dbinfo[1][1]}</div><br>
      <div class="a">Physical Name</div><div>{$data.dbinfo[1][2]}</div><br>
      <div class="a">Size in MB</div><div>{$data.dbinfo[1][4]}Mb</div><br>
      <div class="a">Max Size</div><div>{$data.dbinfo[1][5]}</div>
    </div> 
    <div style="clear:both"></div>
  </div>
</div>

{*TABLE LOG HISTORIAN*}
<div class="box-bdr2">
  <div class="panel3">
    <div style="text-align:left"><i class="fa fa-list"></i>Historian Syncronize Data log</div>
  </div>
  <div class="panel-con">
    <div style="height:300px;overflow:auto"> 
    {if $data.jobLog!=null} 
    <table class="job">
    <thead><tr><th width="20px">&nbsp </th><th>Job name</th><th>Step Name</a></th><th>Status</a></th><th>Message</a></th><th>Run Date/time</a></th><th>Duration</a></th></tr></thead>
    <tbody>
    {foreach $data.jobLog as $job}
    {if $job.2=='Succeeded'}
    <tr>
    <td align="center"><i class="fa fa-check-square" title="Success"></i></td>
    {else}
    <tr class="txtErr">
    <td align="center"><i class="fa fa-close" title="Failed"></i></td>
    {/if}
    <td>{$job.0}</td><td>{$job.1}</td><td>{$job.2}</td><td>{$job.3}</td><td>{$job.4}</td><td>{$job.5} Minutes</td>
    </tr>
    {/foreach}
    </tbody>
    </table>
    {/if}
    </div>
  </div>
</div>
{/strip}

<script type="text/javascript">
$(document).ready(function(){
  $('#loader').show();
	chart({$data.disk.used_P},{$data.disk.free_P},{$data.disk.free_mb},{$data.disk.dbsize},{$data.disk.dbsize_P});
  $('#loader').hide();
});
</script>