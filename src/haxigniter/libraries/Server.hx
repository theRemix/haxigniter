package haxigniter.libraries;

class Server
{
	/**
	 * Shortcut to the DocumentRoot variable.
	 */
	public static var DocumentRoot : String = untyped __var__('_SERVER', 'DOCUMENT_ROOT');
	
	/**
	 * Gives access to any php $_SERVER variable.
	 * @param	varName
	 * @return  the variable as a string.
	 */
	public static inline function Param(parameter : String) : String
	{
		return untyped __var__('_SERVER', parameter);
	}
	
	/**
	 * Implementation of the php function dirname(). Return value is without appending slash.
	 * Note: If there are no slashes in path, a dot ('.') is returned, indicating the current directory.
	 * @param	path
	 * @return  given a string containing a path to a file, this function will return the name of the directory.
	 */
	public static function dirname(path : String) : String
	{
		var slashIndex = path.lastIndexOf('/');
		if(slashIndex >= 0)
			return path.substr(0, slashIndex);

		// Test for windows backslash
		slashIndex = path.lastIndexOf('\\');
		if(slashIndex >= 0)
			return path.substr(0, slashIndex);
		
		return '.';
	}
}