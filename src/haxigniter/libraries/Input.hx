package haxigniter.libraries;

class Input 
{
	public static inline function Post(param : String) : String
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

	public static inline function Get(param : String) : String
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
	
	public static inline function IpAddress() : String
	{
		return haxigniter.libraries.Server.Param('REMOTE_ADDR');
	}
}