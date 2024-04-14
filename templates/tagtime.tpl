{strip}
<script type="text/javascript">
$(function(){
	$('select').change(function(){
		var rate = $(this).val();
		if(rate == "other"){									
			$("input").attr('disabled', false);
			$("input").focus();
		}
		else{ $("input").attr('disabled', true); }
	});
});
</script>
<style>.form .row{ margin-left:20px }</style>
<div class="judul left"><i class="fa fa-lg fa-cogs"></i><b>Tags Data Time Interval Configuration</b></div>
<div class="clear"></div>

<div style="height:100px;margin:10px;">
{if $data.msg.info}<div>{$data.msg.info}</div>{/if}
{if $data.msg.error}<div>{$data.msg.error}</div>{/if}
</div>
 
<div class="box-bdr" style="width:600px;margin:auto">
	<div class="panel">
    <i class="fa fa-lg fa-clock-o"></i><b>Current Interval Time : {$data.time.current}</b>
	</div>
	<form method="post" class="form ui-helper-clearfix" style="min-height:0px">
		<div class="row">
			<label>Time Interval</label>
			<select name="time[select]">
				<option value="">-Rate Time-</option>
				<option value=1800 {if $data.time.select==1800}selected{/if}> 30 Minutes</option>
				<option value=3600 {if $data.time.select==3600}selected{/if}> 1 Hour </option>
				<option value=5400 {if $data.time.select==5400}selected{/if}> 1.5 Hour </option>
				<option value=7200 {if $data.time.select==7200}selected{/if}> 2 Hour </option>
        <option value='other' {if $data.time.oth}selected{/if}> Other </option>
			</select>
		</div>
		<div class="row">
			<label>Other</label>
      <input name="time[oth]" type="text" {if !$data.time.oth}disabled{/if} value="{$data.time.oth}" placeholder="minutes"> <i class="disabled">*not less than 30minutes</i>
		</div>
		<div class="panel-btm"><button class="btn btn-xs btn-default"><span class="ui-icon ui-icon-circle-check"></span>Save</button></div>
	</form>
</div>
{/strip}