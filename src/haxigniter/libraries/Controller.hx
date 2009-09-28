package haxigniter.libraries;

import haxigniter.libraries.Config;
import haxigniter.libraries.Database;
import haxigniter.libraries.Debug;

import haxigniter.views.ViewEngine;
import haxigniter.application.config.Session;

/**
 * If you want your controller to handle its request processing by itself, 
 * implement this interface and you will have full control.
 */
interface CustomRequest
{
	/**
	 * Handle a page request.
	 * @param	uriSegments Array of request segments (URL splitted with "/")
	 * @param	method Request method, "GET" or "POST" most likely.
	 * @param	params Query parameters
	 * @return  Any value that the controller returns.
	 */
	function customRequest(uriSegments : Array<String>, method : String, params : Hash<String>) : Dynamic;
}

class Controller implements haxe.rtti.Infos
{
	public var application(getApplication, null) : haxigniter.Application;
	private function getApplication() : haxigniter.Application { return haxigniter.Application.instance(); }

	public var config(getConfig, null) : Config;
	private function getConfig() : Config { return application.config; }

	public var view(getView, null) : ViewEngine;
	private function getView() : ViewEngine { return application.view; }

	public var db(getDb, null) : DatabaseConnection;
	private function getDb() : DatabaseConnection { return application.db; }

	public var session(getSession, null) : Session;
	private function getSession() : Session { return application.session; }	
	
	///// Convenience methods for debug and logging /////////////////
	
	private function trace(data : Dynamic, ?debugLevel : DebugLevel, ?pos : haxe.PosInfos) : Void
	{
		Debug.trace(data, debugLevel, pos);
	}
	
	private function log(message : Dynamic, ?debugLevel : DebugLevel) : Void
	{
		Debug.log(message, debugLevel);
	}
}
