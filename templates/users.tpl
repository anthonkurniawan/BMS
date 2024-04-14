{strip}
{if !$q.print}
 <a href="user.php" class="right btn btn-sm btn-primary"> <i class="fa fa-user-plus"></i> Add new user</a>
 <div style="clear:right"></div>

<div class="ui-helper-clearfix judul">
	<span class="left"><i class="fa fa-lg fa-users"></i><b>User Management</b></span>
	<span class="right disabled">{if $data.count} {$data.count} {else} 0 {/if} records found</span>
</div>
{else}
 <h5>User Management</h5>
{/if}

{if $data.msg.info}{$data.msg.info}{/if}

<div class="box-bdr">
	<table class="report">
		<thead><tr><th>Department</th><th>Username</th><th>Full Name</th><th>Email</th><th>Position</th><th>Status</th><th>Priviledges</th>{if !$q.print}<th colspan="2">Action</th>{/if}</tr></thead>
		<tbody>
		{if !$q.print}
		<form method="post">
			<input name="r_page" type="hidden" id="q_page" value={$q.page}>
			<input name="print" type="hidden" id="q_print">
			<tr class="filter">
				<td>
					<select name="q[dept]">
						<option value='' {if $q.dept==''}selected{/if}>All</option>
						{html_options options=$q.depts selected=$q.dept}
					</select>
				</td> 
				<td><input type="text" name="q[uname]" value="{$q.uname}"></td>
				<td><input type="text" name="q[fname]" value="{$q.fname}"></td>
				<td><input type="text" name="q[email]" value="{$q.email}"></td>
				<td>
					<select name="q[pos]">
						<option value='' {if $q.pos==''}selected{/if}>All</option>
						<option value='int' {if $q.pos=='int'}selected{/if}> Initiator </option>
						<option value='spv' {if $q.pos=='spv'}selected{/if}> Supervisor </option>
						<option value='admin' {if $q.pos=='admin'}selected{/if}> Administrator </option>
					</select>
				</td> 
				<td>
					<select name="q[st]">
						<option value='' {if $q.st==''}selected{/if}>All</option>
						<option value='2' {if $q.st=='2'}selected{/if}>Active</option>
						<option value="1" {if $q.st=='1'}selected{/if}>Inactive</option>
					</select>
				</td> 
				<td><input type='text' name='q[priv]' value="{$q.priv}"></td>
				<td>
					<button type="submit" class="btn btn-sm btn-default" onClick="bms.qreport(null,false,event)"><span class="ui-icon ui-icon-search"></span>Find</button>
					<button class="btn btn-sm btn-default" type="reset">Reset</button>
				</td>
			</tr>
			</form>
			{/if}
      {if $data.users}
			{foreach $data.users as $u}
			<tr {($u.status==1) ? "class=disabled" :""}>
				<td>{dept d=$u.dept}</td>
				<td align="left">
					{if $q.print} {$u.username} {else}<a href="userlog.php?u={$u.username}" title="User log {$u.username}"><i class="ui-icon ui-icon-folder-collapsed"></i>{$u.username}</a>{/if}
				</td>
				<td>{$u.fullname}</td>
				<td>{if $q.print} {$u.email} {else}<a href="mailto:{$u.email}" title="Send email to: {$u.email}"><i class="ui-icon ui-icon-mail-closed"></i>{$u.email}</a></td>{/if}
				<td>{if $u.position=='int'} Initiator{elseif $u.position=='spv'} Supervisor {elseif $u.position=='admin'} Administrator {/if}</td>
				<td>{if $u.status==2}Active{else}Inactive{/if}</td>
				<td>{$u.priviledges}</td>
				{if !$q.print}
				<td align="center">
					<div class="btn-group btn-group-sm">
						<a href="user.php?id={$u.id}"class="btn btn-sm btn-default"><i class="ui-icon ui-icon-pencil"></i>Edit</a>
						{if $u.status==2}
						<span class="btn btn-sm btn-default" onclick="act('inactive','{$u.id}','{$u.username}')"> <i class="ui-icon ui-icon-arrowthickstop-1-s"></i>Inactive</span>
						{else}
						<span class="btn btn-sm btn-default" onclick="act('active','{$u.id}','{$u.username}')"><i class="ui-icon ui-icon-arrowthickstop-1-n"></i>Active</span>
						{/if}
					</div>
				</td>
				{/if}
			</tr>
			{/foreach}
			{else}
			<tr><td colspan="8" height="400px">{$data.msg.error}</td></tr>
			{/if}
		</tbody>
	</table>
</div>

{if $data.users && !$q.print}
<div class="ui-helper-clearfix panel-btm">
	<div class="pager left">{$data.pages}</div> 
	<div class="pager-nav left">{$data.pager}</div>
  <span class="right btn btn-xs btn-primary print" onclick="bms.qreport(null,1,event)"><i class="fa fa-file-excel-o"></i>export</span>
</div>

<script type="text/javascript">
function act(act, id, u){ {*console.log(act, id, u);*}
	if(confirm('Are you sure want to '+act+' '+u+'?')){
		bms.ajaxCall(null, 'json', { act:act,id:id }, function(rs){
			bms.setMsg(rs,'ui-state-highlight','ui-icon-info');
			setTimeout(function(){ window.location.reload(); }, 400)
		});
	}
}
</script>
{/if}
{/strip}