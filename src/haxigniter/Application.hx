package haxigniter;

import haxigniter.libraries.Config;

import haxigniter.libraries.Controller;
import haxigniter.libraries.Url;
import haxigniter.libraries.Debug;
import haxigniter.libraries.Database;

// This important package imports all application controllers so they will be referenced by the compiler.
// See application/config/Config.hx for more info.
import haxigniter.application.config.Controllers;
import haxigniter.application.config.Session;
import haxigniter.application.config.Database;

import haxigniter.rtti.RttiUtil;
import haxigniter.types.TypeFactory;

import haxigniter.views.ViewEngine;

#if php
typedef InternalSession = php.Session;
#elseif neko
typedef InternalSession = neko.Session;
#end

class Application
{
	public var config(getConfig, never) : haxigniter.application.config.Config;
	private function getConfig() : haxigniter.application.config.Config { return haxigniter.application.config.Config.instance(); }

	public var controller(getController, null) : Controller;
	private var my_controller : Controller;
	private function getController() : Controller
	{
		if(this.my_controller == null)
			throw new haxigniter.exceptions.Exception('Controller has not been executed yet.');
		
		return this.my_controller;
	}

	public var DB(getDB, null) : DatabaseConnection;
	private static var db : DatabaseConnection;
	private function getDB() : DatabaseConnection
	{
		// Database is a resource-intensive object, so it's created on demand.
		if(Application.db == null)
		{
			if(this.config.development)
				Application.db = new DevelopmentConnection();
			else
				Application.db = new OnlineConnection();
			
			Application.db.open();
		}
		
		return Application.db;
	}
	
	public var view(getView, null) : ViewEngine;
	private function getView() : ViewEngine { return this.config.view; }
	
	public var session(getSession, null) : Session;
	private static var my_session : Session;
	private function getSession() : Session
	{
		if(Application.my_session == null)
		{
			if(InternalSession.exists(sessionName))
			{
				Application.my_session = InternalSession.get(sessionName);
			}
			else
			{
				Application.my_session = new haxigniter.application.config.Session();
				InternalSession.set(sessionName, Application.my_session);
			}
		}
		
		return Application.my_session;
	}
	
	///// Static vars ///////////////////////////////////////////////

	public static var instance = new Application();

	private static var defaultController : String = 'start';
	private static var defaultMethod : String = 'index';
	
	private static var defaultNamespace : String = 'haxigniter.application.controllers';
	private static var sessionName : String = '__haxigniter_session';
	
	///// Application entrypoint ////////////////////////////////////

	public static function main()
	{
		if(Application.instance.config.development)
		{
			// Run the haXigniter unit tests and the application.
			Application.runTests();
			Application.instance.run(Url.segments);
		}
		else
		{
			// TODO: When rethrow is fixed, factorize this code to Application.instance.run()
			try
			{
				Application.instance.run(Url.segments);
			}
			catch(controller : ControllerException)
			{
				haxigniter.libraries.Server.error404();
			}
			catch(e : Dynamic)
			{
				Debug.log(e, DebugLevel.error);
				Application.genericError();
			}
		}
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
	
	public function new() {}
	
	public function run(uriSegments : Array<String>) : Void
	{
		var controllerClass : String = (uriSegments[0] == null) ? Application.defaultController : uriSegments[0];
		var controllerMethod : String = (uriSegments[1] == null) ? Application.defaultMethod : uriSegments[1];

		controllerClass = Application.defaultNamespace + '.' + controllerClass.substr(0, 1).toUpperCase() + controllerClass.substr(1);
		
		// Instantiate a controller with this class name.
		var classType : Class<Dynamic> = Type.resolveClass(controllerClass);
		if(classType == null)
			throw new ControllerException(controllerClass + ' not found. (Is it defined in config/Controllers.hx?)');
		
		// TODO: Controller arguments?
		this.my_controller = cast Type.createInstance(classType, []);

		var method : Dynamic = Reflect.field(this.controller, controllerMethod);
		if(method == null)
			throw new ControllerException(controllerClass + ' method "' + controllerMethod + '" not found.');

		// Typecast the arguments.
		var arguments : Array<Dynamic> = this.typecastArguments(classType, controllerMethod, uriSegments.slice(2));
		
		// Before calling the controller, start session so no premature output will mess with it.
		if(config.sessionPath != '')
			this.startSession();
		
		// TODO: When rethrow is fixed, factorize this code so errors will be logged in development too.
		if(this.config.development)
		{
			// Execute the controller with no exception handling in development mode.
			Reflect.callMethod(this.controller, method, arguments);

			// Decided to close session here, not in cleanup, because of session integrity.
			// It may be in a bad state if exception is thrown.
			#if neko
			this.closeNekoSession();
			#end
		}
		else
		{
			try
			{
				// Execute the controller class with the method specified, and the arguments.
				Reflect.callMethod(this.controller, method, arguments);

				// Decided to close session here, not in cleanup, because of session integrity.
				// It may be in a bad state if exception is thrown.
				#if neko
				this.closeNekoSession();
				#end
			}
			catch(e : Dynamic)
			{
				Debug.log(e, DebugLevel.error);
				Application.genericError();				
			}			
		}

		// Clean up controller after it's done.
		this.cleanup();
	}
	
	private function startSession()
	{
		InternalSession.setSavePath(config.sessionPath);
		InternalSession.start();
	}
	
	#if neko
	private function closeNekoSession()
	{
		if(Application.my_session != null)
		{
			InternalSession.set(sessionName, Application.my_session);
			InternalSession.close();
		}
	}
	#end
	
	private function cleanup()
	{
		// Close database connection
		if(this.controller.DB != null)
			this.controller.DB.close();
	}
	
	/**
	* Cast arguments to controller (from Uri) to correct type, throwing TypeException if typecast fails.
	*/
	private function typecastArguments(classType : Class<Dynamic>, classMethod : String, arguments : Array<String>) : Array<Dynamic>
	{
		var output : Array<Dynamic> = [];
		
		var methods : Hash<List<CArgument>> = RttiUtil.getMethods(classType);
		var c = 0;
		
		for(method in methods.get(classMethod))
		{
			// Test if value is optional, then push a null argument.
			if(method.opt && (arguments[c] == '' || arguments[c] == null))
			{
				++c;
				output.push(null);
			}
			else
			{
				// The methods come in the same order as the arguments, so match each argument with a method type.
				output.push(TypeFactory.createType(method.type, arguments[c++]));
			}
		}

		return output;		
	}
}
