{strip}
<style>img.user{ margin:30px 30px 5px 30px;padding:10px;height:110px;width:110px } img.user.nopic{ padding:10px;height:110px}</style>
<div class="ui-helper-clearfix judul">
	<span class="left" style="margin-top:10px"><i class="fa fa-lg fa-user-plus"></i><b>{$data.act}</b></span>
	<a href="users.php" class="right btn btn-sm btn-primary"> <i class="fa fa-users" title="User Management"></i>User Management</a>
</div>

{if $data.msg}{$data.msg.info}{$data.msg.error}{/if}
 
<div class="box-bdr" style="margin-top:5px">
  <div class="panel"><i class="fa fa-lg fa-arrow-circle-o-down"></i><b>Please Fill-in New User's Data</b></div>

	<form method="post" enctype="multipart/form-data" class="form ui-helper-clearfix">		
		<div class="left" style="margin-left:20px">
			<div class="row"><label for="uname">Username</label><input name="username" id="uname" type="text" value="{$data.user.username}" placeholder="username"> <p class="hint">Username required</p></div>
			<div class="row"><label>Fullname</label><input name="fullname" id="fname" type="text" value="{$data.user.fullname}" placeholder="fullname"><p class="hint">Fullname required</p></div>
			<div class="row"><label>Email</label><input name="email" id="email" type="text" value="{$data.user.email}" placeholder="email address" size="35"><p class="hint">Email required</p></div>
			<div class="row">
				<label>Departement</label>
				<select name="dept" id="dept">
					<option value=''>-Departement-</option>
					{html_options options=$data.depts selected=$data.user.dept}
				</select>
				<p class="hint">Departement required</p>
			</div>
		</div>

		<div class="left" style="margin-left:100px">
			<div class="row"><label for="pic">Signature pic</label><input type="file" name="pic" id="pic" value="{$data.user.sign}"></div>
			<div class="row">
				<label>Position</label>
				<select name="position" id="pos">
					<option value="">-Position-</option>
					<option value='int' {if $data.user.position=='int'}selected{/if}> Initiator </option>
					<option value='spv' {if $data.user.position=='spv'}selected{/if}> Supervisor </option>
					<option value='admin' {if $data.user.position=='admin'}selected{/if}> Administrator </option>
				</select>
				<p class="hint">Position required</p>
			</div>
			<div id="spv-con" {if $data.user.spv}style="display:block"{else} class="hide" {/if}>
				<div class="row">
					<label>Supervisor-1</label>
					<select name="spv[]" id="spv1">
						{if $data.user.spvOpt}<option value="">-Supervisor1-</option>{html_options options=$data.user.spvOpt selected=$data.user.spv.0}{/if}
					</select>
				</div>
				<div class="row">
					<label>Supervisor-2</label>
					<select name="spv[]" id="spv2">
						{if $data.user.spvOpt}<option value="">-Supervisor1-</option>{html_options options=$data.user.spvOpt selected=$data.user.spv.1}{/if}
					</select>
				</div>
			</div>
		</div>
			
		<div class="right" style="text-align:center;margin-right:100px">
			{if $data.user.sign}
			<img class="user" src="images/sign/{$data.user.sign}"> <br><small class="disabled">{$data.user.sign}</small>
			{else}
			<img class="user nopic" alt="No Signature Picture">
			{/if}
		</div>	
		<div class="clear"></div>
			
		<div class="row" style="margin: 27px 0px 0px 0px;">
			<div style="padding:2px; border-bottom:1px solid gray;"><strong>Privileges*</strong></div>
			<table>
				<thead>
				<tr style="background-color:#3E4156;color:white;font-size:11px;height:20px"><th>Engineering</th><th>Production</th><th>Material</th><th>Quality Operation</th><th>Quality Assurance</th></tr>
				</thead>
				<tbody>
				<tr height="25">
					<td align="center"> <input id="eng" name='priv["eng"]' type="checkbox" {if isset($data.user.priv.eng)}checked{/if}></td>  
					<td align="center"> <input id="prod" name='priv["prod"]' type="checkbox" {if isset($data.user.priv.prod)}checked{/if}> </td>   
					<td align="center"> <input id="wh" name='priv["wh"]' type="checkbox" {if isset($data.user.priv.wh)}checked{/if}> </td>
					<td align="center"> <input id="qo" name='priv["qo"]' type="checkbox" {if isset($data.user.priv.qo)}checked{/if}> </td>
					<td align="center"> <input id="qa" name='priv["qa"]' type="checkbox" {if isset($data.user.priv.qa)}checked{/if}> </td>
				</tr> 
				</tbody>
			</table>
		</div>
			
		<div class="panel-btm"><a class="btn btn-xs btn-default" id="submit"><span class="ui-icon ui-icon-circle-check"></span> Save</a></div>
		<input name="sign" type="hidden" value="{$data.user.sign}">
		<input name="id" type="hidden" value="{$data.user.id}">
		<input name="usernameX" type="hidden" value="{$data.user.username}">
	</form>
</div>

<script type="text/javascript">
	$(document).ready(function(){
		$(':input:not(:checkbox,:hidden,[name*=spv])').change(function(){ {*sconsole.log($(this), $(this).val())*}
			var el=$(this); 
			(!el.val()) ? el.parent().addClass('error') : el.parent().removeClass('error');
		});
		
		$(':checkbox').change(function(){
      if($('input:checkbox').is(':checked')){
				$(this).parents('.row').removeClass('ui-state-error');
				getSpv();
			}else{
				$(this).parents('.row').addClass('ui-state-error');
			}
		});
		
		$('#submit').click(function(){ 
			var priv=$('[name*="priv"]'), pic = $("#pic").val();
			var iptvldt = bms.inputValidate(':input:not(:checkbox,:hidden,[name=sign],[name*=spv])',true);
			var picvldt = picValidate(pic);	console.log('i-validate :'+iptvldt,'pic-validate :'+picvldt);
					
			if(!iptvldt||!picvldt){ console.log('salah false');
				return false
			}
			if(!priv.is(':checked')){
				priv.parents('.row').addClass('ui-state-error');
				bms.setMsg('Please assign at least one priviledge', 'ui-state-error','ui-icon-alert');
				return false
			}  
			$('form').submit();
		});
		$("#pos").change(getPriv);
		$("#pos").change(getSpv);
		$("#dept").change(getPriv);
		$("#dept").change(getSpv);
	
		function getSpv(){ {*console.log('GET-SPV val:'+this.value+ " dept:"+$('#dept').val());*}
			if($('#pos').val()=="int" && $('#dept').val()!=''){ 
			  var inputs = $('input:checkbox'), priv='', c=0;
			  $.each(inputs, function(i,v){ 
			    if($(v).is(':checked')){ 
			      priv += (c === 0 ? '"'+v.id+'"' : ',"'+v.id+'"');
			      c++;
			    }
			  });
			  
				bms.ajaxCall('./api.php?q=spv&dept='+priv,'json',null,function(rs){
					bms.buildSelect(rs,'[name="spv[]"]','-Supervisor-');
					$('#spv-con').fadeIn('slow');
				});
			}else{
				$('[name="spv[]"]').children().remove();
				$('#spv-con').fadeOut();
			}
		}
		function getPriv(){
			if($('#pos').val()=='admin'||($('#pos').val()=='spv'&&$('#dept').val()=='qa')){
				$('[name*="priv"]').prop('checked',true);
			}else if($('#dept').val()=='qa'){
			  $('[name*="priv"]').prop('checked',false);
			  $('#qa').prop('checked',true);
			  $('#qo').prop('checked',true);
			}else{
				$('[name*="priv"]').prop('checked',false);
        $("[name='priv[\""+$('#dept').val()+"\"]']").prop('checked',true);
			}
		}
		
		function picValidate(pic){
			if(pic){
				var ext = pic.substr(pic.lastIndexOf('.')+1);	{*console.log('pic :'+pic, ext);*}
        if(ext=="gif"||ext=="GIF"||ext=="JPEG"||ext=="jpeg"||ext=="jpg"||ext=="JPG"||ext=="png"){
					return true;
				}else{
					bms.setMsg('File not supported', 'ui-state-error','ui-icon-alert');return false;
				}
			}
			return true;
		}
	});
</script>
{/strip}
