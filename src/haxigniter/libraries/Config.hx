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
	* This class is abstract, so constructor is private.
	*/
	private function new() 
	{
		if(this.BaseUrl == null)
		{
			this.BaseUrl = Server.Param('SERVER_PORT') == '443' ? 'https' : 'http';
			this.BaseUrl += '://' + Server.Param('HTTP_HOST');
			this.BaseUrl += StringTools.replace(Server.Param('SCRIPT_NAME'), this.IndexPage, '');
		}		
	}	
}
