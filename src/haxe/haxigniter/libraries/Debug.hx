package haxigniter.libraries;

import php.Lib;

class Debug
{
	public static function trace(data : Dynamic, ?pos : haxe.PosInfos)
	{
#if php
		php.Lib.print('<pre>');

		untyped __call__('ob_start');
		haxe.Log.trace(data, pos);
		php.Lib.print(StringTools.htmlEscape(untyped __call__('ob_get_clean')));

		php.Lib.print('</pre>');
#else
		haxe.Log.trace(data, pos);
#end
	}
}