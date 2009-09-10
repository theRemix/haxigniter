package haxigniter.libraries;

import haxigniter.application.config.Config;

import haxigniter.libraries.Database;
import haxigniter.application.config.Database;

import haxigniter.views.ViewEngine;

class Application
{
	public var Config(getConfig, null) : Config;
	private var config : Config;
	private function getConfig() : Config { return this.config; }

	public var DB(getDB, null) : DatabaseConnection;
	private var db : DatabaseConnection;
	private function getDB() : DatabaseConnection
	{
		// Database is a resource-intensive object, so it's created on demand.
		if(this.db == null)
		{
			if(this.Config.Development)
				this.db = new DevelopmentConnection();
			else
				this.db = new OnlineConnection();
			
			this.db.Open();
		}
		
		return this.db;
	}
	
	public var View(getView, null) : ViewEngine;
	private function getView() : ViewEngine { return this.Config.View; }
	
	// TODO: Session
	
	public function new()
	{
		// Config is used internally, so it's created when instantiating.
		this.config = new haxigniter.application.config.Config();
	}
	
	public static var Instance = new Application();
}