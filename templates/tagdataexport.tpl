{strip}
<html>
<body>
	<h5>{$unit.label}</h5>
	{if $error}
	  <table><tr><td>{$error}</td></tr></table>
	{else}
		{if $report.tdata}{include file=$unit.file}{/if}
	{/if}
</body>
</html>
{/strip}
