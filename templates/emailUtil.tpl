{strip}
<style>
.form{ min-height:400px }
.form label{ width:180px }
.form .hint{ padding-left:190px }
.box-bdr{ min-width:700px;margin:5px auto }
.judul{ height:30px !important}
input.add{ margin-right: -6px; }
input.new{ margin-left:190px;margin-top:2px; }
.debug{ display:none;border:1px solid black;background:#1B1A5C;color:#01F745;margin:5px 0px;padding:2px;font-size:11px;max-height:150px;overflow-y:auto; }
.animate-container{ position:relative;background:white;overflow:hidden;/*border:1px solid black;*/}
.panel,.animate{ padding:10px}
#con-1.animate, #con-2.animate{ display:block;transition:all cubic-bezier(0.250, 0.460, 0.450, 0.940) 1.5s;position:absolute;top:0;left:0;right:0;bottom:0;}
#con-1.animate{ position:relative;}
#con-2.animate{ left:100%;}
#con-1.animate.ng-leave-active{ left:-100%;}
#con-2.animate.ng-enter-active{ left:0;}
</style>

<script type="text/javascript">
$(function(){
	$(':input:not(select,button)').change(function(){ console.log($(this), $(this).val());
		var el=$(this); 
		(!el.val()) ? el.parent().addClass('error') : el.parent().removeClass('error');
	});
	
	$('#submit').click(function(){
    bms.dismisMsg();
		if(!bms.inputValidate('#form1 input:not(:hidden)',true))
			return false;
		$('#kirim').val(1);
		$('form#form1').submit();
	});
	
	$('#mailTest').click(function(){
		if(!bms.inputValidate('#form2 :input:not(select)',true))
			return false;
		var data = $('form#form2').serializeArray();
		$('.debug').fadeOut();
		bms.ajaxCall('./api.php?q=mailtest', 'json', data, function(rs){
			var debug = rs.debug;
			if($('[name="setting[SMTPDebug]"]').val()!=0);
				$('.debug').fadeIn().html(debug);
			if(rs.success)
				bms.setMsg(rs.success, 'ui-state-highlight','ui-icon-info');
			else bms.setMsg(rs.error, 'ui-state-error','ui-icon-alert');
		});
	});
	
	$('.btn-add:first').click(function(){
		$(this).after('<div><input class="add new" type="text" placeholder="email address" name="address[]" size="30"> <span class="btn btn-sm btn-default btn-add" onclick="$(this).parent().parent().removeClass(\'error\');$(this).parent().remove();";>x</span></div>');
	});

	$('.toggleSlide').click(function(){
    bms.dismisMsg();
		if($('#con-1').hasClass('ng-leave-active')){
			$('#con-2 .toggleSlide').hide(1000,'swing');
			$('#con-2').removeClass('ng-enter-active');
			$('#con-1').removeClass('ng-leave-active');
		}else{
			$('#con-2 .toggleSlide').show(1000,'swing');
			$('#con-2').addClass('ng-enter-active');
			$('#con-1').addClass('ng-leave-active');
		}
	});
});
</script>

<div class="animate-container">
	{*EMAIL CONFIG*}
	<div id="con-1" class="animate">
		<div class="ui-helper-clearfix judul">
			<span class="left" style="margin-top:10px;"><img src="images/mailcfg.png" width="20" height="20"><b>Email Configuration</b></span>
			<span class="right btn btn-sm btn-primary toggleSlide"><i class="fa fa-envelope" title="test mail"></i>Test Email</span>
		</div>

		{if $data.msg.info}<div>{$data.msg.info}</div>{/if}
		{if $data.msg.error}<div>{$data.msg.error}</div>{/if}
		 
		<div class="box-bdr">
			<div class="panel"><i class="fa fa-lg fa-arrow-circle-o-down"></i><b>Please fill all fields correctly</b></div>
			<form method="post" id="form1" class="ui-helper-clearfix form" style="padding:0px 20px">
				<input id="kirim" name="kirim" type="hidden">
				<div class="row">
          <label>Host</label>
          <input name="Host" type="text" value="{$data.email.Host}">
          <i class="note">The SMTP Host</i><p class="hint">Host is required</p>
        </div>
				<div class="row"><label>Port</label><input name="Port" type="text" value="{$data.email.Port}" size="5"><p class="hint">SMTP Port is required</p> <i class="note">The default SMTP server port.</i></div>
				<div class="row"><label>Email Address</label><input name="From" type="text" value="{$data.email.From}" size="30"> <p class="hint">Email Addres is required</p><i class="note">The From email address for the message.</i></div>
				<div class="row"><label>Display Name Email From</label><input name="FromName" type="text" value="{$data.email.FromName}" size="30"> <p class="hint">Display Email From is required</p><i class="note">Display name</i></div>
				<div class="row">
					<label>Email Priority</label>
					<select name="Priority">
						<option value='' {if $data.email.Priority==''}selected{/if}> Default </option>
						<option value=1 {if $data.email.Priority==1}selected{/if}>High</option>
						<option value=3 {if $data.email.Priority==3}selected{/if}>Normal</option>
						<option value=5 {if $data.email.Priority==5}selected{/if}>Low</option>
					</select>
					<i class="note"> null (default), 1 = High, 3 = Normal, 5 = low.</i>
				</div>
				<div class="row">
					<label>Email Content Type</label>
					<select name="ContentType">
						<option value='text/html' {if $data.email.ContentType=='text/html'}selected{/if}>Text/Html</option>
						<option value='text/plain' {if $data.email.ContentType=='text/plain'}selected{/if}>Text/Plain</option>
					</select>
					<i class="note">'text/plain', 'text/html'</i>
				</div>
				<div class="row"><label>Sending TimeOut</label><input name="Timeout" type="text" value="{$data.email.Timeout}"> <i class="note"> Default of 5 minutes (300sec)</i></div>
			</form>
			<div class="panel-btm">
				<button id="submit" class="btn btn-sm btn-default"><span class="ui-icon ui-icon-circle-check"></span>Save</button>
			</div>
		</div>
	</div>
	
	{*TEST MAIL*}
	<div id="con-2" class="animate">
		<div class="ui-helper-clearfix judul">
			<span class="left" style="margin-top:10px"><i class="fa fa-envelope" title="test mail"></i><b>Test Email</b></span>
			<span class="right btn btn-sm btn-primary toggleSlide" style="display:none"><img src="images/mailcfg2.png"/> Email Configuration</span>
		</div>
		 
		<div class="box-bdr">
			<div class="panel"><i class="fa fa-lg fa-arrow-circle-o-down"></i><b>Please fill correct fields</b></div>
			<form method="post" id="form2" class="ui-helper-clearfix form" style="padding:0px 20px">
				<div class="row">
					<label>Address</label>
					<input class="add" type="text" placeholder="email address" name="address[]" size="30">
					<span class="btn btn-sm btn-default btn-add"><i class="ui-icon ui-icon-mail-closed"></i>Others</span>
					<p class="hint">Address is required</p> 
				</div>
					
				<div class="row"><label>Message</label><textarea name='message' cols="50" rows="5"></textarea> <p class="hint">Please write your message</p> </div>
				<div class="row">
					<label>SMTP Debug</label>
					<select name="setting[SMTPDebug]">
						<option value=0 {if $data.email.SMTPDebug==0}selected{/if}>No output</option>
						<option value=1 {if $data.email.SMTPDebug==1}selected{/if}>Commands</option>
						<option value=2 {if $data.email.SMTPDebug==2}selected{/if}>Data and command</option>
						<option value=3 {if $data.email.SMTPDebug==3}selected{/if}>With connection status</option>
						<option value=4 {if $data.email.SMTPDebug==4}selected{/if}>Low-level data output</option>
					</select>
					<i class="note">Debug sending info</i>
				</div>
				<div class="row">
					<label>Debug Output</label>
					<select name="setting[Debugoutput]">
						<option value='echo' {if $data.email.Debugoutput=='echo'}selected{/if}>Output plain-text as-is</option>
						<option value='html' {if $data.email.Debugoutput=='html'}selected{/if}>Html</option>
					</select>
					<i class="note">Debug format options</i>
				</div>
				<div class="debug"></div>
			</form>	
			
			<div class="panel-btm">
				<button id="mailTest" class="btn btn-sm btn-default"><span class="ui-icon ui-icon-circle-check"></span>Send</button>
			</div>
		</div>
	</div>
</div>
{/strip}
