package haxigniter.libraries;

class Server
{
	/**
	 * Shortcut to the DocumentRoot variable.
	 */
	public static var documentRoot : String;
	
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
		return Server.params.get(parameter);
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
	
	/////////////////////////////////////////////////////////////////

	private static function __init__()
	{
		#if neko
		Server.params = new Hash<String>();
		
		var root = Server.parseDocumentRoot();
		
		Server.params.set('DOCUMENT_ROOT', root[0]);		
		Server.params.set('REQUEST_URI', neko.Web.getURI());
		Server.params.set('REMOTE_ADDR', neko.Web.getClientIP());
		Server.params.set('HTTP_HOST', neko.Web.getHostName());

		// Neko only parameter: Web path to script, with trailing slash.
		Server.params.set('SCRIPT_PATH', root[1]);
		#end
		
		// Need to specify the document root here because of neko init.
		Server.documentRoot = Server.param('DOCUMENT_ROOT');
	}
	
	#if neko
	private static var params : Hash<String>;

	/**
	 * Returns An array with two elements:
	 * 0 - Equivalent to DOCUMENT_ROOT
	 * 1 - Web path to executing script, with trailing slash.
	 */
    private static function parseDocumentRoot() : Array<String>
    {
		// TODO: If directories have the same name, this can fail.
    	var cwd : Array<String> = neko.Web.getCwd().split('/');
    	var uri : Array<String> = neko.Web.getURI().split('/');
		
    	if(cwd[cwd.length-1] == '')
    		cwd.pop();

    	if(uri[0] == '')
    		uri.shift();

    	var i = cwd.length - 1;
    	while(i >= 0)
    	{
    		if(cwd[i] == uri[0])
			{
    			return [cwd.slice(0, i).join('/'), 
						'/' + cwd.slice(i, cwd.length).join('/') + '/'];
			}
			
			--i;
    	}
		
    	return [cwd.join('/'), '/'];
    }
	#end
}
