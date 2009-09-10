package haxigniter.libraries; 

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

	/**
	* This class is abstract, so constructor is private.
	*/
	private function new() 
	{
		if(this.SessionPath != null)
		{
			php.Session.setSavePath(this.SessionPath);
		}
		
		if(this.BaseUrl == null)
		{
			this.BaseUrl = untyped __var__('_SERVER', 'SERVER_PORT') == '443' ? 'https' : 'http';
			this.BaseUrl += '://' + untyped __var__('_SERVER', 'HTTP_HOST');
			this.BaseUrl += StringTools.replace(untyped __var__('_SERVER', 'SCRIPT_NAME'), this.IndexPage, '');	
		}		
	}	
}
