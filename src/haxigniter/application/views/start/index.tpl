<h2>Welcome to {$application}!</h2> 

{if $id !== null}
	<p>Looks like the id was "{$id}".</p>
{else}
	<p>You didn't enter any id. Here's a <a href="{$link}start/index/123">free one<a>!</p>
{/if}