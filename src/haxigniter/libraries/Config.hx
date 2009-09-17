package haxigniter.libraries; 

import haxigniter.libraries.Debug;
import haxigniter.views.ViewEngine;

import haxigniter.libraries.Server;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

class Config
{
	public var development(default, null) : Bool;

	public var indexPath(default, null) : String;
	public var siteUrl(default, null) : String;
	public var applicationPath(default, null) : String;
	public var viewPath(default, null) : String;
	public var logPath(default, null) : String;
	public var cachePath(default, null) : String;
	public var sessionPath(default, null) : String;
	
	//public var language(default, null) : String;
	//public var charset(default, null) : String;
	public var permittedUriChars(default, null) : String;
	public var logLevel(default, null) : DebugLevel;
	public var logDateFormat(default, null) : String;
	public var encryptionKey(default, null) : String;
	
	public var view(default, null) : ViewEngine;
	
	private var runtimePath : String;

	/**
	 * Not used in child classes, setting non-initialized constants.
	 */
	private function new()
	{
		// ApplicationPath and BaseUrl always goes on top, since other vars will probably use them.
		
		if(this.applicationPath == null)
		{
			applicationPath = Web.getCwd();
			
			var indexPos : Int = -1;
			var indexDir = Server.dirname(this.indexPath);
			
			if(indexDir != '.')
				indexPos = applicationPath.lastIndexOf(indexDir);
			
			if(indexPos > -1)
				applicationPath = applicationPath.substr(0, indexPos);

			this.applicationPath += 'lib/haxigniter/application/';			
		}
		
		if(this.siteUrl == null)
		{
			#if php
			// PHP detects both SSL and host name with port, so a full url can be generated.
			siteUrl = Server.param('SERVER_PORT') == '443' ? 'https' : 'http';
			siteUrl += '://' + Server.param('HTTP_HOST') + '/' + this.indexPath;
			#elseif neko
			// Neko cannot detect SSL, so a short form of the URL is returned in this case.
			// TODO: Can SSL be detected on neko somehow?
			siteUrl = '/' + this.indexPath;			
			#end
		}
		
		// Set runtime path based on application path.
		this.runtimePath = this.applicationPath + 'runtime/';

		// Other paths that can be specified in config.
		if(this.viewPath == null)
		{
			this.viewPath = this.applicationPath + 'views/';
		}
			
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
}
