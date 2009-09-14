package haxigniter.libraries; 

import haxigniter.libraries.Server;
import haxigniter.libraries.Debug;
import haxigniter.views.ViewEngine;

class Config
{
	public var development : Bool;
	public var indexPage : String;
	public var baseUrl : String;
	public var language : String;
	public var charset : String;
	public var permittedUriChars : String;
	public var logLevel : DebugLevel;
	public var logPath : String;
	public var logDateFormat : String;
	public var cachePath : String;
	public var privatePath : String;
	public var encryptionKey : String;
	public var view : ViewEngine;	
	public var applicationPath : String;

	private var runtimePath : String;
	private var viewPath : String;
	
	public var sessionPath(getSessionPath, setSessionPath) : String;
	private var my_sessionPath : String;
	private function getSessionPath() : String { return this.my_sessionPath; }
	private function setSessionPath(path : String)
	{
		php.Session.setSavePath(path);
		this.my_sessionPath = path;
		
		return this.my_sessionPath;
	}
	
	/**
	 * Set constants that is not dependent on other config variables.
	 */
	private function initConstants() {}
	
	/**
	 * Not used in child classes, setting non-initialized constants.
	 */
	private function initDefaults() 
	{
		// ApplicationPath and BaseUrl always goes on top, since other vars will probably use them.
		
		if(this.applicationPath == null)
		{
			this.applicationPath = Server.documentRoot;
			this.applicationPath += StringTools.replace(Server.param('SCRIPT_NAME'), this.indexPage, '');
			this.applicationPath += 'lib/haxigniter/application/';
		}
		
		if(this.baseUrl == null)
		{
			this.baseUrl = Server.param('SERVER_PORT') == '443' ? 'https' : 'http';
			this.baseUrl += '://' + Server.param('HTTP_HOST');
			this.baseUrl += StringTools.replace(Server.param('SCRIPT_NAME'), this.indexPage, '');
		}

		// Set runtime and view path based on application path.
		this.runtimePath = this.applicationPath + 'runtime/';
		this.viewPath = this.applicationPath + 'views/';
		
		// Other paths that can be specified in config.
		if(this.cachePath == null)
		{
			this.cachePath = this.runtimePath + 'cache/';
		}
		
		if(this.logPath == null)
		{
			this.logPath = this.runtimePath + 'logs/';
		}

		if(this.sessionPath == null)
		{
			this.sessionPath = this.runtimePath + 'session/';
		}
	}
	
	/**
	 * Set variables that are dependent on other config variables or default values.
	 * Inherited by application.config.config
	 */
	private function initDependencies() {}

	/**
	* This class is abstract, so constructor is private.
	*/
	private function new() 
	{
		initConstants();
		initDefaults();
		initDependencies();
	}
}
