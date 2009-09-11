package haxigniter.libraries; 

import haxigniter.libraries.Server;
import haxigniter.libraries.Debug;
import haxigniter.views.ViewEngine;

class Config implements Dynamic 
{
	public var Development : Bool;
	public var IndexPage : String;
	public var BaseUrl : String;
	public var Language : String;
	public var Charset : String;
	public var PermittedUriChars : String;
	public var LogThreshold : DebugLevel;
	public var LogPath : String;
	public var LogDateFormat : String;
	public var CachePath : String;
	public var PrivatePath : String;
	public var EncryptionKey : String;
	public var View : ViewEngine;	
	public var ApplicationPath : String;

	private var runtimePath : String;
	private var viewPath : String;
	
	public var SessionPath(getSessionPath, setSessionPath) : String;
	private var sessionPath : String;
	private function getSessionPath() : String { return this.sessionPath; }
	private function setSessionPath(path : String)
	{
		php.Session.setSavePath(path);
		this.sessionPath = path;
		
		return this.sessionPath;
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
		
		if(this.ApplicationPath == null)
		{
			this.ApplicationPath = Server.DocumentRoot;
			this.ApplicationPath += StringTools.replace(Server.Param('SCRIPT_NAME'), this.IndexPage, '');
			this.ApplicationPath += 'lib/haxigniter/application/';
		}
		
		if(this.BaseUrl == null)
		{
			this.BaseUrl = Server.Param('SERVER_PORT') == '443' ? 'https' : 'http';
			this.BaseUrl += '://' + Server.Param('HTTP_HOST');
			this.BaseUrl += StringTools.replace(Server.Param('SCRIPT_NAME'), this.IndexPage, '');
		}

		// Set runtime and view path based on application path.
		this.runtimePath = this.ApplicationPath + 'runtime/';
		this.viewPath = this.ApplicationPath + 'views/';
		
		// Other paths that can be specified in config.
		if(this.CachePath == null)
		{
			this.CachePath = this.runtimePath + 'cache/';
		}
		
		if(this.LogPath == null)
		{
			this.LogPath = this.runtimePath + 'logs/';
		}

		if(this.SessionPath == null)
		{
			this.SessionPath = this.runtimePath + 'session/';
		}
	}
	
	/**
	 * Set variables that are dependent on other config variables or default values.
	 * Inherited by application.config.Config
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
