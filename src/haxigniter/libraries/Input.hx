package haxigniter.libraries;

class Input 
{
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
	
	public static inline function ipAddress() : String
	{
		return haxigniter.libraries.Server.param('REMOTE_ADDR');
	}
}
