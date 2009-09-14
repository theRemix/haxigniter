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
	private function getApplication() : haxigniter.Application { return haxigniter.Application.instance; }

	public var config(getConfig, null) : Config;
	private function getConfig() : Config { return application.config; }

	public var view(getView, null) : ViewEngine;
	private function getView() : ViewEngine { return application.view; }

	public var DB(getDB, null) : DatabaseConnection;
	private function getDB() : DatabaseConnection { return application.DB; }

	public var session(getSession, null) : Session;
	private function getSession() : Session { return application.session; }	
}
