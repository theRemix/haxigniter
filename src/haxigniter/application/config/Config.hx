package haxigniter.application.config;

import haxigniter.libraries.Debug; 
import haxigniter.libraries.Server;

#if php
import php.Sys;
import php.Web;
#elseif neko
import neko.Sys;
import neko.Web;
#end

class Config extends haxigniter.libraries.Config
{
	private function new()
	{
		/*
		|--------------------------------------------------------------------------
		| Development mode
		|--------------------------------------------------------------------------
		|
		| Development mode is used to auto-detect many things in the system, like
		| database connection, paths, etc. This setting should also be 
		| auto-detected, so you can just upload the application to a live server
		| and it should just work.
		|
		| Here are a few examples for auto-detecting development mode:
		|
		| If you're on a Windows machine when developing and Linux when live:
		|    this.development = Sys.getEnv('OS') == 'Windows_NT';
		|
		| To test depending on host name: 
		|    this.development = Web.getHostName() == 'localhost';
		|
		| Or IP address (PHP only):
		|    this.development = Server.Param('SERVER_ADDR') == '127.0.0.1';
		|
		*/
		development = Sys.getEnv('OS') == 'Windows_NT';

		/* ===================================================================== */
		/* === Paths ============================================================*/
		/* ===================================================================== */
		
		/*
		|--------------------------------------------------------------------------
		| Index file web Path
		|--------------------------------------------------------------------------
		|
		| This should be the web path to your index file. For example, if you're
		| using PHP and haXigniter is located in the folder "haxigniter" below the
		| document root, this should be set to "haxigniter/index.php". 
		|
		| For neko, this will be "haxigniter/index.n". If your application is in
		| the root of the web server, it will be just "index.php".
		|
		| If you are using mod_rewrite to remove the index page, set this variable 
		| to the path only, or blank of in the root.
		| 
		| NOTE: This is the only path that should be without a trailing and 
		|       prepending slash!
		|
		*/
		#if php
		indexPath = 'index.php';
		#elseif neko
		indexPath = 'index.n';
		#end

		/*
		|--------------------------------------------------------------------------
		| Site URL
		|--------------------------------------------------------------------------
		|
		| URL to your haXigniter root. If null it will be autodetected. If you want 
		| to specify it, it's a normal URL:
		|
		|	http://www.your-site.com/path/to/index.php
		|
		*/
		siteUrl = null;
		
		/*
		|--------------------------------------------------------------------------
		| Application Path
		|--------------------------------------------------------------------------
		|
		| Full server path to the application. Set automatically based on indexPath.
		|
		*/
		applicationPath = null;
		
		/*
		|--------------------------------------------------------------------------
		| Views Directory Path
		|--------------------------------------------------------------------------
		|
		| Set to null unless you would like to set something other than the default
		| application/views/ folder. Use a full server path with trailing slash.
		|
		*/
		viewPath = null;
		
		/*
		|--------------------------------------------------------------------------
		| Error Logging Directory Path
		|--------------------------------------------------------------------------
		|
		| Set to null unless you would like to set something other than the default
		| application/runtime/logs/ folder. Use a full server path with trailing slash.
		|
		*/
		logPath = null;

		/*
		|--------------------------------------------------------------------------
		| Cache Directory Path
		|--------------------------------------------------------------------------
		|
		| Set to null unless you would like to set something other than the default
		| application/runtime/cache/ folder. Use a full server path with trailing slash.
		|
		*/
		cachePath = null;

		/*
		|--------------------------------------------------------------------------
		| Session Path
		|--------------------------------------------------------------------------
		|
		| Set to null unless you would like to set something other than the default
		| application/runtime/session/ folder. Use a full server path with trailing slash.
		|
		| If you want to disable session, set this value to an empty string.
		|
		*/
		sessionPath = null;

		/* ===================================================================== */
		/* === Other =========================================================== */
		/* ===================================================================== */

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
		//language = 'english';

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
		//charset = 'UTF-8';

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
		permittedUriChars = 'a-z 0-9~%.:_-'; //'a-z 0-9~%.:=_Â‰ˆ≈ƒ÷·È¸-';

		/*
		|--------------------------------------------------------------------------
		| Error Logging Threshold
		|--------------------------------------------------------------------------
		|
		| You can enable error logging by setting a threshold over Off. The
		| threshold determines what gets logged. Threshold options are:
		|
		|	DebugLevel.off = Disables logging, Error logging TURNED OFF
		|	DebugLevel.error = Error Messages (including PHP errors)
		|	DebugLevel.warning = Warning Messages
		|	DebugLevel.info = Info Messages
		|	DebugLevel.verbose = All Messages
		|
		| For a live site you'll usually only enable Error or Warning otherwise
		| your log files will fill up very fast.
		|
		*/
		logLevel = this.development ? DebugLevel.info : DebugLevel.warning;

		/*
		|--------------------------------------------------------------------------
		| Date Format for Logs
		|--------------------------------------------------------------------------
		|
		| Each item that is logged has an associated date. You can use PHP strftime
		| codes to set your own date formatting.
		|
		*/
		logDateFormat = '%Y-%m-%d %H:%M:%S';

		/*
		|--------------------------------------------------------------------------
		| Encryption Key
		|--------------------------------------------------------------------------
		|
		| If you use the Encryption class or the Sessions class with encryption
		| enabled you MUST set an encryption key.  See the user guide for info.
		|
		*/
		encryptionKey = '';

		/*
		|--------------------------------------------------------------------------
		| Error page
		|--------------------------------------------------------------------------
		|
		| haxigniter.libraries.Server.error() can be used to display an error page
		| when things go wrong.
		|
		| If you want to use a view page as an error page, set it here. For example
		| "errors/error.mtt"
		|
		| If it's set to null, the template in application/views/error.html will
		| be used for display, with a generic error message.
		|
		*/
		errorPage = null;

		/*
		|--------------------------------------------------------------------------
		| Error 404 page
		|--------------------------------------------------------------------------
		|
		| haxigniter.libraries.Server.error404() can be used to display the 404
		| error page (not found error). Correct headers are sent automatically.
		|
		| If you want to use a view page as this error page, set it here. For 
		| example "errors/error404.mtt"
		|
		| If it's set to null, the template in application/views/error.html will
		| be used for display, with a generic error 404 message.
		|
		*/
		error404Page = null;
		
		/* ================================================================= */
		/* Superclass must be called at the end to populate default values.  */
		/* ================================================================= */
		super();
		/* ================================================================= */
	}

	/*
	 * Initialize objects here that depends on configuration settings.
	 */
	private function newObjects()
	{
		/*
		|--------------------------------------------------------------------------
		| View Engine
		|--------------------------------------------------------------------------
		|
		| The Views are displayed by a ViewEngine, which is any class extending 
		| the haxigniter.views.viewEngine class.
		|
		| Because the ViewEngine requires access to Config variables, the ViewEngine
		| class cannot be instantiated here. A class name must be specified here.
		| The two engines supplied by haXigniter are:
		|
		| 	haxigniter.views.templo - The Templo 2 engine. (http://haxe.org/com/libs/mtwin/templo)
		|   haxigniter.views.haxeTemplate - haxe.Template (http://haxe.org/doc/cross/template)
		|
		| If you want to use another template system, make a class extending
		| haxigniter.views.viewEngine and specify it here.
		|		
		*/
		view = new haxigniter.views.Smarty();
	}
	
	/* ================================================================= */
	/* ===== End of configuration settings ============================= */
	/* ================================================================= */

	private static var my_instance : Config;
	public static function instance() : Config
	{
		if(my_instance == null)
		{
			my_instance = new Config();
			my_instance.newObjects();
		}
		
		return my_instance;
	}
}
