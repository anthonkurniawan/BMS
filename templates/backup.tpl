{strip}
<style>
.db-note{ margin:0px;text-align:left;float:left}
.db-note div{ float:left}
.db-note div.label{ font-weight:bold; width:140px;clear:left}
.db-note div.label2{ font-weight:bold; width:100px;clear:left}
.db-note div.val{ font-size:12px }
#pie, #gauge_db, #row_max{ float:left;width:300px;height:250px}
.panel3{ padding:8px}
.box-bdr2{ margin:5px 0px 20px 0px}
tr td .fa{ color:blue; margin-left:5px}
tr.txtErr td .fa{ color:red}
table tbody tr td.dbsize { text-align:right }
label.status { margin:0 }
#status_dis, #status_en { vertical-align:bottom }
table.log th { background-Color:white }
</style>

<div class="box-bdr2">
  <div class="panel3">
    <div style="text-align:left"><i class="fa fa-database"></i>Backup</div>
  </div>

  <div class="panel-con">
		<div class="db-note" style="min-width:200px;width:70%">
			<div class="label">Data Base Name</div> <div class="val">{$data.dbinfo2[0][0]}</div><br>
			<!-- <div class="label">Crate Date</div> <div class="val">{$data.dbinfo2[0][1]}</div><br> -->
			<div class="label">Recovery Model</div> <div class="val">{$data.dbinfo2[0][2]}</div><br>
      <!-- <div class="label">Data Physical Name</div> <div class="val">{$data.dbinfo[0][1]}</div><br> -->
      <!-- <div class="label">Log Physical Name</div> <div class="val">{$data.dbinfo[1][1]}</div><br> -->
			<div class="label">Location:</div> <div class="val">{$data.backupTargetLabel}</div> <br>
			<button id="submit" class="btn btn-lg btn-primary" onclick="backup()">Backup Now</button>
    </div>
		
    <div class="db-note">
			<b>Automatic Backup Schedule</b> <br>
			<div class="label2">Job name</div> <div class="val">{$data.jobInfo[0][0]}</div><br>
			<div class="label2">Status</div> 
			<div>
				<input type="checkbox" id="status_en" name="status_en" {if $data.jobInfo[0][1]==1}checked{/if}>
				<label for="status_en" class="status">Enable</label>
			</div>
			<div class="label2">&nbsp</div> 
			<div>
				<input type="checkbox" id="status_dis" name="status_dis" {if $data.jobInfo[0][1]==0}checked{/if}>
				<label for="status_dis" class="status">Disabled</label>
			</div>
			<div class="label2">Last Run</div> <div class="val">{$data.jobInfo[0][3]}</div> <br>
			<!-- <div class="label">Created</div> <div class="val">{$data.jobInfo[0][2]}</div><br> -->
		</div>
		
		<div class="db-note" style="margin-top:10px; min-width:200px;width:99%">
      <b>Backup History</b>
      <div class="box-bdr" style="width:100%; height:300px; text-align:center">
				{if $data.backupLog!=null} 
				<table class="log">
					<tr>
					<!-- <th>Database</th><th>Server</th>-->
					<!-- <th>User</th> -->
					<th>Time</th>
					<!-- <th>Time</th> -->
					<!-- <th>End-time</th> -->
					<th>Type</th>
					<!-- <th>File Backup</th> -->
					<th>File</th>
					<th>Size</th>
					<!-- <th>Size MB</th> -->
					<th>Duration</th>
					<th style="border-right:0">Recovery Model</th></tr>
					{foreach $data.backupLog as $bak}
					<tr>
						<!-- <td>{$bak.0}</td> -->
						<!-- <td>{$bak.1}</td> -->
						<!-- <td>{$bak.2}</td> -->
						<td>{$bak.7}</td>
						<!-- <td>{$bak.8}</td> -->
						<!-- <td>{$bak.7}</td> -->
						<td>{$bak.3}</td>
						<!-- <td>{$bak.4}</td>  -->
						<!-- <td> {link file=$bak.4 backupDir=$data.backupDir} </td> -->
						{if $bak.12}
						<td><a href="{$bak.12}" target="_blank" download> {$bak.4} <i class="fa fa-download"></i></td>
						{else}
						<td>{$bak.4}</td>
						{/if}
						{if $bak.5 < 1000000}
						<td class="dbsize">{$bak.5} B</td>
						{else}
						<td class="dbsize">{$bak.6}</td>
						{/if}
						<td>{$bak.10}</td>
						<td style="text-align:center">{$bak.11}</td>
					</tr>
					{/foreach}
				</table>
				{else}
					<div style="margin-top:135px;float:none">
						<i>don't have any backup</i>
					</div>
				{/if}
      </div>
    </div> 
    <div style="clear:both"></div>
</div>

{/strip}

<script type="text/javascript">
$(document).ready(function(){
	$('input[type=checkbox]').change(function(){ console.log($(this), $(this).is(':checked'));
		var el = $(this);
		var enable, disable;
		if(el.is(':checked')) {
			if(el[0].name == 'status_en')
				$('input[name=status_dis]')[0].checked = false;
			else
				$('input[name=status_en]')[0].checked = false;
		} else {
			if(el[0].name == 'status_en')
				$('input[name=status_dis]')[0].checked = true;
			else
				$('input[name=status_en]')[0].checked = true;
		}
		
		//if($('input[name=status_en]').is(':checked')) {
		//	enable = 1;
		//	disable = 0;
		//} else {
		//	enable = 0;
		//	disable = 1;
		//}
		//console.log('enable:' + enable);
		bms.ajaxCall('./api.php?q=switch-backup-job', 'json', null, function(rs){
			bms.setMsg("Update Successfull..",'ui-state-highlight','ui-icon-info');
			setTimeout(function(){ 
				bms.dismisMsg();
			}, 1000);
		});
		
	});
});

function backup() {
	bms.ajaxCall('./api.php?q=db-backup', 'json', { filename:'{$data.backupTarget}' }, function(rs){
		bms.setMsg("Backup Successfull..",'ui-state-highlight','ui-icon-info');
		setTimeout(function(){ window.location.reload(); }, 1000);
	});
}
</script>
