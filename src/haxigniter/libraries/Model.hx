package haxigniter.libraries;

import haxigniter.Application;

import haxigniter.libraries.Debug;

import haxigniter.application.config.Config;
import haxigniter.libraries.Controller;
import haxigniter.libraries.Database;
import haxigniter.application.config.Session;

class ModelException extends haxigniter.exceptions.Exception {}

class Model
{
	public var application(getApplication, null) : haxigniter.Application;
	private function getApplication() : haxigniter.Application { return haxigniter.Application.instance(); }

	public var controller(getController, null) : Controller;
	private function getController() : Controller { return application.controller; }

	public var config(getConfig, null) : Config;
	private function getConfig() : Config { return application.config; }

	public var DB(getDB, null) : DatabaseConnection;
	private function getDB() : DatabaseConnection { return application.DB; }

	//public var session(getSession, null) : Session;
	//private function getSession() : Session { return application.session; }	
	
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
