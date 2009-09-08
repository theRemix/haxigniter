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
}