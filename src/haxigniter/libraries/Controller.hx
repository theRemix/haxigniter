package haxigniter.libraries;

import haxigniter.libraries.Config;
import haxigniter.views.ViewEngine;
import haxigniter.libraries.Database;
import haxigniter.application.config.Session;
import haxigniter.libraries.Debug;

class ControllerException extends haxigniter.exceptions.Exception {}

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
