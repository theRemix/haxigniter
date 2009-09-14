package haxigniter.libraries;

import haxigniter.Application;

import haxigniter.application.config.Config;
import haxigniter.libraries.Controller;
import haxigniter.libraries.Database;
import haxigniter.application.config.Session;

//class ModelException extends haxigniter.exceptions.exception {}

class Model
{
	public var config(getConfig, null) : Config;
	private function getConfig() : Config { return Application.Instance.config; }

	public var controller(getController, null) : Controller;
	private function getController() : Controller { return Application.Instance.controller; }

	public var DB(getDB, null) : DatabaseConnection;
	private function getDB() : DatabaseConnection { return Application.Instance.DB; }

	public var session(getSession, null) : Session;
	private function getSession() : Session { return Application.Instance.session; }
}
