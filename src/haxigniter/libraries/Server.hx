package haxigniter.libraries;

#if php
import php.io.File;
import php.Lib;
import php.Web;
#elseif neko
import neko.io.File;
import neko.Lib;
import neko.Web;
#end

class Server
{
	#if php
	/**
	 * Convenience method for external libraries.
	 * @param	path
	 */
	public static function requireExternal(path : String) : Void
	{
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
	
	public static function error404()
	{
		// TODO: Multiple languages
		Server.error('404 Not Found', '404 Not Found', 'The page you requested was not found.', 404);
	}
	
	public static function error(title : String, header : String, message : String, returnCode : Int = null)
	{
		var config = haxigniter.application.config.Config.instance();
		
		var errorPage = returnCode == 404 ? config.error404Page : config.errorPage;
		
		if(returnCode != null)
			Web.setReturnCode(returnCode);
		
		if(errorPage == null)
		{
			var content = File.getContent(config.applicationPath + 'views/error.html');
			content = StringTools.replace(content, '::TITLE::', title);
			content = StringTools.replace(content, '::HEADER::', header);
			content = StringTools.replace(content, '::MESSAGE::', message);
			
			Lib.print(content);
		}
		else
		{
			config.view.display(errorPage);
		}
	}
	
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
