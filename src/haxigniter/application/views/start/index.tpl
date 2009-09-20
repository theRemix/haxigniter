<h2>Welcome to {$name}, my humble lord!</h2> 
The habitants are: 
<ul>
	{foreach from=$users item=user}
		<li>
			{$user->name} - 
			{if $user->age > 18}
				Grownup
			{elseif $user->age < 3}
				Baby
			{else}
				Young
			{/if}
		</li>
	{/foreach}
</ul>
