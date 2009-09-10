package haxigniter.libraries;

import haxigniter.Application;

import haxigniter.application.config.Config;
import haxigniter.views.ViewEngine;
import haxigniter.libraries.Database;

class ControllerException extends haxigniter.exceptions.Exception {}

class Controller implements haxe.rtti.Infos
{
	public var Config(getConfig, null) : Config;
	private function getConfig() : Config { return Application.Instance.Config; }

	public var View(getView, null) : ViewEngine;
	private function getView() : ViewEngine { return Application.Instance.View; }

	public var DB(getDB, null) : DatabaseConnection;
	private function getDB() : DatabaseConnection { return Application.Instance.DB; }
}