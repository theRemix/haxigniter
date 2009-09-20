package haxigniter.libraries;

class Server
{
	#if php
	/**
	 * Convenience method for external libraries.
	 * @param	path
	 */
	public static inline function requireExternal(path : String) : Void
	{
		// TODO: Config class must be completed before this can be called! How to solve?
		untyped __call__('require_once', haxigniter.application.config.Config.instance().applicationPath + 'external/' + path);
	}

	/**
	 * Gives access to any php $_SERVER variable.
	 * @param	varName
	 * @return  the variable as a string, or null if variable didn't exist.
	 */
	public static inline function param(parameter : String) : String
	{
		try
		{
			return untyped __var__('_SERVER', parameter);
		}
		catch(e : String)
		{
			return null;
		}
	}
	#end
	
	/**
	 * Implementation of the php function dirname(). Return value is without appending slash.
	 * Note: If there are no slashes in path, a dot ('.') is returned, indicating the current directory.
	 * @param	path
	 * @return  given a string containing a path to a file, this function will return the name of the directory.
	 */
	public static function dirname(path : String) : String
	{
		#if php
		return php.io.Path.directory(path);
		#elseif neko
		var output = neko.io.Path.directory(path);
		return output.length == 0 ? '.' : output;
		#end
	}
}
