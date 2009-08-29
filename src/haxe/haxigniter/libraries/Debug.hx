package haxigniter.libraries;

import php.Lib;

enum DebugLevel
{
	Off;
	Error;
	Warning;
	Info;
	Verbose;
}

class Debug
{
	public static var Level : DebugLevel = Info;
	
	public static function trace(data : Dynamic, ?debugLevel : DebugLevel, ?pos : haxe.PosInfos)
	{
		if(debugLevel == null) debugLevel = DebugLevel.Info;
		
		if(Debug.ToInt(debugLevel) > Debug.ToInt(Debug.Level))
			return;
		
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
	
	public static function ToInt(level : DebugLevel) : Int
	{
		return switch(level)
		{
			case Off: 0;
			case Error: 1;
			case Warning: 2;
			case Info: 3;
			case Verbose: 4;
		}
	}
}