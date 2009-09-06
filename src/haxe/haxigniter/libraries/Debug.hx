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
		Debug.StartPhpBuffer();
		
		haxe.Log.trace(data, pos);

		php.Lib.print(StringTools.htmlEscape(Debug.EndPhpBuffer()));
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
	
#if php
	public static function StartPhpBuffer() : Void
	{
		untyped __call__('ob_start');
	}
	
	public static function EndPhpBuffer() : String
	{
		return untyped __call__('ob_get_clean');
	}
#end
}