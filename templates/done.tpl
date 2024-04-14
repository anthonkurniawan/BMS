{strip}
<style>.ui-state-default{ background: #dfeffc}.ui-state-default span{ float: left; margin-right: .3em; }</style>
<div>
{if $data}
	{$data.msg}      
		{if isset($data.direct)}
		<script language="JavaScript" type="text/javascript">//window.setTimeout('window.location="{$data.direct}"', 2000);</script>
		{/if}
	{/if}
</div>
{/strip}