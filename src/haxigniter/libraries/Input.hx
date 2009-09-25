package haxigniter.libraries;

class Input 
{
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
