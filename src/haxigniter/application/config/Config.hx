package haxigniter.application.config;

import haxigniter.libraries.Debug; 
import haxigniter.libraries.Server;

class Config extends haxigniter.libraries.Config 
{
	/**
	 * Variables not dependent on default values.
	 */
	private override function initConstants()
	{
		/*
		|--------------------------------------------------------------------------
		| Development setting
		|--------------------------------------------------------------------------
		|
		| Determine here when the system is in development mode, or set to false.
		| Here are a few examples for auto-detecting:
		|
		| If you're on a Windows machine when developing and Linux when live:
		|    this.Development = php.Sys.getEnv('OS') == 'Windows_NT';
		|
		| To test depending on host name: 
		|    this.Development = php.Web.getHostName() == 'localhost';
		|
		| Or IP address: 
		|    this.Development = Server.Param('SERVER_ADDR') == '127.0.0.1';
		|
		*/
		// TODO: Description for Development mode, usefulness
		this.Development = php.Sys.getEnv('OS') == 'Windows_NT';

		/*
		|--------------------------------------------------------------------------
		| Index File
		|--------------------------------------------------------------------------
		|
		| Typically this will be your index.php file, unless you've renamed it to
		| something else. If you are using mod_rewrite to remove the page set this
		| variable so that it is blank.
		|
		*/
		this.IndexPage = 'index.php';

		/*
		|--------------------------------------------------------------------------
		| Base Site URL
		|--------------------------------------------------------------------------
		|
		| URL to your haxIgniter root. Set to null to auto-detect, which should
		| work most of the time. Typically this will be your base URL, WITH a 
		| trailing slash:
		|
		|	http://www.your-site.com/
		|
		*/
		this.BaseUrl = null;

		/*
		|--------------------------------------------------------------------------
		| URI PROTOCOL
		|--------------------------------------------------------------------------
		|
		| This item determines which server global should be used to retrieve the
		| URI string.  The default setting of "AUTO" works for most servers.
		| If your links do not seem to work, try one of the other delicious flavors:
		|
		| 'AUTO'			Default - auto detects
		| 'PATH_INFO'		Uses the PATH_INFO
		| 'QUERY_STRING'	Uses the QUERY_STRING
		| 'REQUEST_URI'		Uses the REQUEST_URI
		| 'ORIG_PATH_INFO'	Uses the ORIG_PATH_INFO
		|
		*/
		// TODO: Is Uri protocol detection needed?

		/*
		|--------------------------------------------------------------------------
		| Default Language
		|--------------------------------------------------------------------------
		|
		| This determines which set of language files should be used. Make sure
		| there is an available translation if you intend to use something other
		| than english.
		|
		*/
		// TODO: Multiple languages
		//this.Language = 'english';

		/*
		|--------------------------------------------------------------------------
		| Default Character Set
		|--------------------------------------------------------------------------
		|
		| This determines which character set is used by default in various methods
		| that require a character set to be provided.
		|
		*/
		// TODO: Charset handling
		//this.Charset = 'UTF-8';

		/*
		|--------------------------------------------------------------------------
		| Allowed URL Characters
		|--------------------------------------------------------------------------
		|
		| This lets you specify which characters are permitted within your URLs.
		| When someone tries to submit a URL with disallowed characters they will
		| get a warning message.
		|
		| As a security measure you are STRONGLY encouraged to restrict URLs to
		| as few characters as possible.  By default only these are allowed: a-z 0-9~%.:_-
		|
		| Leave blank to allow all characters -- but only if you are insane.
		|
		| DO NOT CHANGE THIS UNLESS YOU FULLY UNDERSTAND THE REPERCUSSIONS!!
		|
		| NOTE: When adding swedish charaters, the dash must be placed after them
		| and the equal sign before... Must be some regexp problem.
		*/
		this.PermittedUriChars = 'a-z 0-9~%.:_-'; //'a-z 0-9~%.:=_Â‰ˆ≈ƒ÷·È¸-';

		/*
		|--------------------------------------------------------------------------
		| Error Logging Threshold
		|--------------------------------------------------------------------------
		|
		| You can enable error logging by setting a threshold over Off. The
		| threshold determines what gets logged. Threshold options are:
		|
		|	DebugLevel.Off = Disables logging, Error logging TURNED OFF
		|	DebugLevel.Error = Error Messages (including PHP errors)
		|	DebugLevel.Warning = Warning Messages
		|	DebugLevel.Info = Info Messages
		|	DebugLevel.Verbose = All Messages
		|
		| For a live site you'll usually only enable Error or Warning otherwise
		| your log files will fill up very fast.
		|
		*/
		this.LogLevel = this.Development ? DebugLevel.Info : DebugLevel.Warning;

		/*
		|--------------------------------------------------------------------------
		| Error Logging Directory Path
		|--------------------------------------------------------------------------
		|
		| Leave this BLANK unless you would like to set something other than the default
		| system/logs/ folder.  Use a full server path with trailing slash.
		|
		*/
		this.LogPath = null;

		/*
		|--------------------------------------------------------------------------
		| Date Format for Logs
		|--------------------------------------------------------------------------
		|
		| Each item that is logged has an associated date. You can use PHP strftime
		| codes to set your own date formatting.
		|
		*/
		this.LogDateFormat = '%Y-%m-%d %H:%M:%S';

		/*
		|--------------------------------------------------------------------------
		| Cache Directory Path
		|--------------------------------------------------------------------------
		|
		| Leave this BLANK unless you would like to set something other than the default
		| system/cache/ folder.  Use a full server path with trailing slash.
		|
		*/
		this.CachePath = null;

		/*
		|--------------------------------------------------------------------------
		| Encryption Key
		|--------------------------------------------------------------------------
		|
		| If you use the Encryption class or the Sessions class with encryption
		| enabled you MUST set an encryption key.  See the user guide for info.
		|
		*/
		this.EncryptionKey = null;

		/*
		|--------------------------------------------------------------------------
		| Private Directory Path
		|--------------------------------------------------------------------------
		|
		| Set this to a folder outside the http document root where the web server
		| has access. Can be used for session, sensitive data, etc.
		| Use a full server path with trailing slash.
		|
		| A tip is to use Server.DocumentRoot to specify a folder one step above
		| the http folder. For example:
		|
		| this.PrivatePath = Server.Dirname(Server.DocumentRoot) + '/www_private/';
		|
		*/
		this.PrivatePath = Server.Dirname(Server.DocumentRoot) + '/www_private/';
	}
	
	/**
	* Variables dependent on default values.
	*/
	private override function initDependencies()
	{
		/*
		|--------------------------------------------------------------------------
		| View Engine
		|--------------------------------------------------------------------------
		|
		| The Views are displayed by a ViewEngine, which is any class extending 
		| the haxigniter.views.ViewEngine class.
		|
		| Because the ViewEngine requires access to Config variables, the ViewEngine
		| class cannot be instantiated here. A class name must be specified here.
		| The two engines supplied by haXigniter are:
		|
		| 	haxigniter.views.Templo - The Templo 2 engine. (http://haxe.org/com/libs/mtwin/templo)
		|   haxigniter.views.HaxeTemplate - haxe.Template (http://haxe.org/doc/cross/template)
		|
		| If you want to use another template system, make a class extending
		| haxigniter.views.ViewEngine and specify it here.
		|
		*/
		this.View = new haxigniter.views.Templo(this.viewPath, this.CachePath);
	}

	public function new() {	super(); }
}
