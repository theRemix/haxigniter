package haxigniter.libraries;

class Server
{
	/**
	 * Shortcut to the DocumentRoot variable.
	 */
	public static var documentRoot : String = Server.param('DOCUMENT_ROOT');
	
	/**
	 * Gives access to any php $_SERVER variable.
	 * @param	varName
	 * @return  the variable as a string, or null if variable didn't exist.
	 */
	public static inline function param(parameter : String) : String
	{
		#if php
		try
		{
			return untyped __var__('_SERVER', parameter);
		}
		catch(e : String)
		{
			return null;
		}
		#elseif neko
		return Server.Params.get(parameter);
		#end
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
	
	/**
	 * Convenience method for external libraries.
	 * @param	path
	 */
	#if php
	public static inline function requireExternal(path : String) : Void
	{
		untyped __call__('require_once', haxigniter.Application.instance.config.applicationPath + 'external/' + path);		
	}
	#end

	#if neko
	private static var Params = new Hash<String>();
	
	private static function __init__()
	{
		Server.Params['DOCUMENT_ROOT'] = Server.parseDocumentRoot();
		Server.Params['REQUEST_URI'] = neko.Web.getURI();
		Server.Params['REMOTE_ADDR'] = neko.Web.getClientIP();
		Server.Params['SERVER_NAME'] = neko.Web.getHostName();
	}
	
    private static function parseDocumentRoot() : String
    {
    	var cwd : Array<String> = neko.Web.getCwd().split('/');
    	var uri : Array<String> = neko.Web.getURI().split('/');
    	
    	if(cwd[cwd.length-1] == '')
    		cwd.pop();

    	if(uri[0] == '')
    		uri.shift();

    	var i = cwd.length - 1;
    	while(i >= 0)
    	{
    		if(cwd[i--] == uri[0])
    			return cwd.slice(0, i+1).join('/');
    	}
    	
    	return cwd.join('/');
    }
	#end
}
