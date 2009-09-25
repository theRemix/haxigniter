package haxigniter;

import haxigniter.libraries.Config;

import haxigniter.libraries.Controller;
import haxigniter.libraries.Url;
import haxigniter.libraries.Debug;
import haxigniter.libraries.Database;
import haxigniter.libraries.Request;

// This important package imports all application controllers so they will be referenced by the compiler.
// See application/config/Config.hx for more info.
import haxigniter.application.config.Controllers;
import haxigniter.application.config.Session;
import haxigniter.application.config.Database;

import haxigniter.views.ViewEngine;

#if php
typedef SessionLib = php.Session;
#elseif neko
typedef SessionLib = neko.Session;
#end

class Application
{
	public var config(getConfig, never) : haxigniter.application.config.Config;
	private function getConfig() : haxigniter.application.config.Config { return haxigniter.application.config.Config.instance(); }

	public var db(getDb, null) : DatabaseConnection;
	private static var my_db : DatabaseConnection;
	private function getDb() : DatabaseConnection
	{
		// Database is a resource-intensive object, so it's created on demand.
		if(Application.my_db == null)
		{
			if(this.config.development)
				Application.my_db = new DevelopmentConnection();
			else
				Application.my_db = new OnlineConnection();
			
			Application.my_db.open();
		}
		
		return Application.my_db;
	}

	// TODO: Set this to the Application controller, or use a stack that points to the currently executing controller?
	//private var my_controller : Controller;

	public var view(getView, null) : ViewEngine;
	private function getView() : ViewEngine { return this.config.view; }
	
	public var session(getSession, null) : Session;
	private static var my_session : Session;
	private function getSession() : Session
	{
		if(Application.my_session == null)
		{
			if(SessionLib.exists(sessionName))
			{
				Application.my_session = SessionLib.get(sessionName);
			}
			else
			{
				Application.my_session = new haxigniter.application.config.Session();
				SessionLib.set(sessionName, Application.my_session);
			}
		}
		
		return Application.my_session;
	}
	
	///// Static vars ///////////////////////////////////////////////

	private static var my_instance : Application = new Application();
	public static function instance() : Application { return my_instance; }

	private static var sessionName : String = '__haxigniter_session';
	
	///// Application entrypoint ////////////////////////////////////

	public static function main()
	{
		if(Application.instance().config.development)
		{
			// Run the haXigniter unit tests and the application.
			Application.runTests();
		}
		
		Application.instance().run();
	}
	
	public static function runTests()
	{
		new haxigniter.application.tests.TestRunner().runAndDisplayOnError();
	}

	public static function genericError()
	{
		// TODO: Multiple languages
		haxigniter.libraries.Server.error('Page error', 'Page error', 'Something went wrong during the server processing.');
	}
	
	/////////////////////////////////////////////////////////////////

	private function new() {}

	public function run() : Void
	{
		// Before calling the controller, start session so no premature output will mess with it.
		if(config.sessionPath != '')
			this.startSession();

		// TODO: When php rethrow is fixed (2.05), factorize this.
		if(!config.development)
		{
			try
			{
				// Make a request with the current url.
				Request.fromArray(Url.segments);

				// Decided to close session here, not in cleanup, because of session integrity.
				// It may be in a bad state if exception is thrown.
				#if neko
				if(config.sessionPath != '')
					this.closeNekoSession();
				#end
			}
			catch(e : NotFoundException)
			{
				haxigniter.libraries.Server.error404();
			}
			catch(e : Dynamic)
			{
				// Log the message and display a (relatively) user-friendly error page.
				Debug.log(e, DebugLevel.error);
				Application.genericError();
			}
		}
		else
		{
			try
			{
				Request.fromArray(Url.segments);

				#if neko
				if(config.sessionPath != '')
					this.closeNekoSession();
				#end
			}
			catch(e : NotFoundException)
			{
				haxigniter.libraries.Server.error404();
			}
		}

		// Clean up controller after it's done.
		this.cleanup();
	}
	
	private function startSession()
	{
		SessionLib.setSavePath(config.sessionPath);
		SessionLib.start();
	}
	
	#if neko
	private function closeNekoSession()
	{
		if(Application.my_session != null)
		{
			sessionLib.set(sessionName, Application.my_session);
			sessionLib.close();
		}
	}
	#end
	
	private function cleanup()
	{
		// Close database connection
		if(this.db != null)
			this.db.close();
	}	
}
