package haxigniter.libraries;

import haxigniter.libraries.Config;
import haxigniter.views.ViewEngine;
import haxigniter.libraries.Database;
import haxigniter.application.config.Session;
import haxigniter.libraries.Debug;

class ControllerException extends haxigniter.exceptions.Exception {}

class Controller implements haxe.rtti.Infos
{
	public var Application(getApplication, null) : haxigniter.Application;
	private function getApplication() : haxigniter.Application { return haxigniter.Application.Instance; }

	public var Config(getConfig, null) : Config;
	private function getConfig() : Config { return Application.Config; }

	public var View(getView, null) : ViewEngine;
	private function getView() : ViewEngine { return Application.View; }

	public var DB(getDB, null) : DatabaseConnection;
	private function getDB() : DatabaseConnection { return Application.DB; }

	public var Session(getSession, null) : Session;
	private function getSession() : Session { return Application.Session; }	
}