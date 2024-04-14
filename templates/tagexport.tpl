{strip}
<style>.form .row{ margin-left:20px }</style>
<div class="judul left">
	<i class="fa fa-lg fa-file-text"></i><b>Tags Data Export</b>
</div>
<div class="clear"></div>

<div id="msg" style="height:100px;margin:10px;">
{if $data.msg.info}<div>{$data.msg.info}</div>{/if}
{if $data.msg.error}<div>{$data.msg.error}</div>{/if}
</div>

<div class="box-bdr" style="width:600px;margin:auto">
	<div class="panel">
    <i class="fa fa-lg fa-arrow-circle-o-down"></i><b>Please fill all fields</b>
	</div>
	
	<form method="post" class="form ui-helper-clearfix" style="min-height:0px">
		<div class="row">
			<label for="unit">Unit</label>
			<select name="unit">
				<option value='' {if $data.unitselect==''}selected{/if}></option>
				{html_options options=$data.unitlist selected=$data.unitselect}
			</select>
		</div>
		<div class="row">
			<label for="ds">From</label>
			<input type="text" id="ds" name="DateFrom" value="{$data.ds|date_format:"%d-%b-%Y"}" size="10" placeholder="start date">
		</div>
		<div class="row">
			<label for="de">to</label>
			<input type="text" id="de" name="DateTo" value="{$data.de|date_format:"%d-%b-%Y"}" size="10" placeholder="end date">
		</div>
		<div class="panel-btm"><span class="btn btn-xs btn-default print" onclick="bms.qreport(null,1,event)"><i class="fa fa-file-excel-o"></i>export</span></div>
	</form>
</div>
<script type="text/javascript">
$(document).ready(function(){
	$('#msg-con').offset({ top:100 });
});
</script>
{/strip}
