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
		|    this.development = Sys.getEnv('OS') == 'Windows_NT';
		|
		| To test depending on host name: 
		|    this.development = Web.getHostName() == 'localhost';
		|
		| Or IP address: 
		|    this.development = Server.Param('SERVER_ADDR') == '127.0.0.1';
		|
		*/
		// TODO: Description for Development mode, usefulness
		this.development = Sys.getEnv('OS') == 'Windows_NT';

		/*
		|--------------------------------------------------------------------------
		| Index File
		|--------------------------------------------------------------------------
		|
		| Typically this will be your index.php file, unless you've renamed it to
		| something else. For neko, this will be "index.n".
		|
		| If you are using mod_rewrite to remove the page set this variable so that 
		| it is blank.
		|
		*/
		#if php
		this.indexPage = 'index.php';
		#elseif neko
		this.indexPage = 'index.n';
		#end

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
		this.baseUrl = null;

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
		//this.language = 'english';

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
		//this.charset = 'UTF-8';

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
		this.permittedUriChars = 'a-z 0-9~%.:_-'; //'a-z 0-9~%.:=_Â‰ˆ≈ƒ÷·È¸-';

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
		this.logLevel = this.development ? DebugLevel.info : DebugLevel.warning;

		/*
		|--------------------------------------------------------------------------
		| Error Logging Directory Path
		|--------------------------------------------------------------------------
		|
		| Leave this BLANK unless you would like to set something other than the default
		| system/logs/ folder.  Use a full server path with trailing slash.
		|
		*/
		this.logPath = null;

		/*
		|--------------------------------------------------------------------------
		| Date Format for Logs
		|--------------------------------------------------------------------------
		|
		| Each item that is logged has an associated date. You can use PHP strftime
		| codes to set your own date formatting.
		|
		*/
		this.logDateFormat = '%Y-%m-%d %H:%M:%S';

		/*
		|--------------------------------------------------------------------------
		| Cache Directory Path
		|--------------------------------------------------------------------------
		|
		| Leave this BLANK unless you would like to set something other than the default
		| system/cache/ folder.  Use a full server path with trailing slash.
		|
		*/
		this.cachePath = null;

		/*
		|--------------------------------------------------------------------------
		| Encryption Key
		|--------------------------------------------------------------------------
		|
		| If you use the Encryption class or the Sessions class with encryption
		| enabled you MUST set an encryption key.  See the user guide for info.
		|
		*/
		this.encryptionKey = null;

		/*
		|--------------------------------------------------------------------------
		| Private Directory Path
		|--------------------------------------------------------------------------
		|
		| Set this to a folder outside the http document root where the web server
		| has access. Can be used for session, sensitive data, etc.
		| Use a full server path with trailing slash.
		|
		| A tip is to use Server.documentRoot to specify a folder one step above
		| the http folder. For example:
		|
		| this.privatePath = Server.dirname(Server.documentRoot) + '/www_private/';
		|
		*/		
		this.privatePath = Server.dirname(Server.documentRoot) + '/www_private/';

		/*
		|--------------------------------------------------------------------------
		| Session enabled
		|--------------------------------------------------------------------------
		|
		| If you don't need to use session handling, set this variable to false.
		|
		*/
		this.sessionEnabled = true;
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
		this.view = new haxigniter.views.Templo(this.viewPath, this.cachePath);
	}

	public function new() {	super(); }
}
