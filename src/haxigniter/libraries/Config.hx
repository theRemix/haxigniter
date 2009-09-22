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
	public var development : Bool;

	public var indexPath : String;
	public var siteUrl : String;
	public var applicationPath : String;
	public var viewPath : String;
	public var logPath : String;
	public var cachePath : String;
	public var sessionPath : String;
	
	//public var language : String;
	//public var charset : String;
	public var permittedUriChars : String;
	public var logLevel : DebugLevel;
	public var logDateFormat : String;
	public var encryptionKey : String;
	
	public var errorPage : String;
	public var error404Page : String;
	
	public var view : ViewEngine;
	
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
