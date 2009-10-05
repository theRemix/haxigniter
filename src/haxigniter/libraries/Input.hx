﻿package haxigniter.libraries;

// TODO: Fix this class and make it neko-compatible.
class Input 
{
	public static inline function htmlSpecialChars(s : String)
	{
		return StringTools.htmlEscape(s).split('"').join("&quot;").split("'").join("&#039;");
	}
	
	#if php
	public static inline function post(param : String) : String
	{
		try
		{
			return untyped __var__('_POST', parameter);
		}
		catch(e : String)
		{
			return null;
		}		
	}

	public static inline function get(param : String) : String
	{
		try
		{
			return untyped __var__('_GET', parameter);
		}
		catch(e : String)
		{
			return null;
		}		
	}
	#end
}
