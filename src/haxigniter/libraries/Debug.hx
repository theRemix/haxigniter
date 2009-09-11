package haxigniter.libraries;

import php.Lib;
import php.io.File;
import php.io.FileOutput;

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
	public static var TraceLevel : DebugLevel = Info;
	
	private static var config = haxigniter.Application.Instance.Config;
	
	public static function Log(message : Dynamic, ?debugLevel : DebugLevel) : Void
	{
		if(debugLevel == null) debugLevel = DebugLevel.Info;

		if(Debug.ToInt(debugLevel) > Debug.ToInt(config.LogLevel))
			return;
		
		var logFile = config.LogPath + 'log-' + DateTools.format(Date.now(), "%Y-%m-%d") + ".php";
		var output = '';
		
		if(!php.FileSystem.exists(logFile))
			output += "<?php exit; ?>\n\n";
		
		output += Std.string(debugLevel).toUpperCase() + ' - ' + DateTools.format(Date.now(), config.LogDateFormat) + ' --> ' + message + "\n";
		
		var file : FileOutput = php.io.File.append(logFile, false);
		file.writeString(output);
		file.close();
	}
	
	public static function Trace(data : Dynamic, ?traceLevel : DebugLevel, ?pos : haxe.PosInfos) : Void
	{
		if(traceLevel == null) traceLevel = DebugLevel.Info;
		
		if(Debug.ToInt(traceLevel) > Debug.ToInt(Debug.TraceLevel))
			return;
		
		php.Lib.print('<pre style="border:1px dashed green; padding:2px; background-color:#F9F8F6;">');
		Debug.StartBuffer();
		
		haxe.Log.trace(data, pos);
		
		var output = StringTools.htmlEscape(Debug.EndBuffer());

		php.Lib.print(Debug.colorize(output));
		php.Lib.print('</pre>');
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
	
	public static function StartBuffer() : Void
	{
		untyped __call__('ob_start');
	}
	
	public static function EndBuffer() : String
	{
		return untyped __call__('ob_get_clean');
	}
	
	/////////////////////////////////////////////////////////////////
	
	private static function colorize(data : String) : String
	{
		var title : EReg = ~/^([^:]+:\d+:)/;
		
		title.match(data);		
		var header : String = title.matched(1);
		
		data = title.replace(data, '');

		var tabs : EReg = ~/\t/g;
		data = tabs.replace(data, '  ');
		
		var strings : EReg = ~/("[^"]*")/g;
		data = strings.replace(data, '<span style="color:#C31515;">$1</span>');

		var num : EReg = ~/\b(\d+\.?\d*)\b/g;
		data = num.replace(data, '<span style="color:#008000;">$1</span>');

		var bools : EReg = ~/\b(true|false)\b/g;
		data = bools.replace(data, '<span style="color:#1518FF;">$1</span>');

		return '<b>' + header + '</b>' + data;
	}
}