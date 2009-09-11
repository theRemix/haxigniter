package haxigniter.libraries;

import haxigniter.Application;

import haxigniter.application.config.Config;
import haxigniter.libraries.Controller;
import haxigniter.libraries.Database;
import haxigniter.application.config.Session;

//class ModelException extends haxigniter.exceptions.Exception {}

class Model
{
	public var Config(getConfig, null) : Config;
	private function getConfig() : Config { return Application.Instance.Config; }

	public var Controller(getController, null) : Controller;
	private function getController() : Controller { return Application.Instance.Controller; }

	public var DB(getDB, null) : DatabaseConnection;
	private function getDB() : DatabaseConnection { return Application.Instance.DB; }

	public var Session(getSession, null) : Session;
	private function getSession() : Session { return Application.Instance.Session; }
}