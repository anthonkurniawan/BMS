{strip}
{if $home==1}
<ul class="eflat-menu">
{else}
<ul class="eflat-menu a left"> 
	<li><a class="logo" href="index.php" style="padding:7px 6px 4px 6px;"><img src="images/logo_pfizer.png"></a></li> 	
{/if}
  {foreach $menu.list as $i=>$mn}
	{if isset($mn.url)}
		<li><a href="{$mn.url}">{$mn.label}</a></li>
	{else}
		<li>
			<a href="#">{$i}</a>
			<ul class="sub-menu">{foreach $mn as $m}<li><a href="{$m.url}">{$m.label}</a></li>{/foreach}</ul>
		</li>	
	{/if}
{/foreach}
</ul>
{/strip}
