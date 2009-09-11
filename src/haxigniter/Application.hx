package haxigniter;

// This important package imports all application controllers so they will be referenced by the compiler.
// See application/config/Config.hx for more info.
import haxigniter.application.config.Controllers;

import haxigniter.libraries.Url;

import haxigniter.rtti.RttiUtil;
import haxigniter.types.TypeFactory;

import haxigniter.libraries.Config;
import haxigniter.application.config.Session;

import haxigniter.libraries.Controller;

import haxigniter.libraries.Database;
import haxigniter.application.config.Database;

import haxigniter.views.ViewEngine;

class Application
{
	public var Config(getConfig, null) : Config;
	private static var config : Config = new haxigniter.application.config.Config();
	private function getConfig() : Config { return Application.config; }

	public var Controller(getController, null) : Controller;
	private var controller : Controller;
	private function getController() : Controller
	{
		if(controller == null)
			throw new haxigniter.exceptions.Exception('Controller has not been executed yet.');
		
		return this.controller;
	}

	public var DB(getDB, null) : DatabaseConnection;
	private static var db : DatabaseConnection;
	private function getDB() : DatabaseConnection
	{
		// Database is a resource-intensive object, so it's created on demand.
		if(Application.db == null)
		{
			if(this.Config.Development)
				Application.db = new DevelopmentConnection();
			else
				Application.db = new OnlineConnection();
			
			Application.db.Open();
		}
		
		return Application.db;
	}
	
	public var View(getView, null) : ViewEngine;
	private function getView() : ViewEngine { return this.Config.View; }
	
	public var Session(getSession, null) : Session;
	private static var session : Session;
	private function getSession() : Session
	{
		if(Application.session == null)
		{
			if(php.Session.exists(sessionName))
			{
				Application.session = php.Session.get(sessionName);
			}
			else
			{
				Application.session = new haxigniter.application.config.Session();
				php.Session.set(sessionName, Application.session);
			}
		}
		
		return Application.session;
	}
	
	///// Static vars ///////////////////////////////////////////////

	public static var Instance = new Application();

	private static var defaultController : String = 'start';
	private static var defaultMethod : String = 'index';
	
	private static var defaultNamespace : String = 'haxigniter.application.controllers';
	private static var sessionName : String = '__haxigniter_session';
	
	///// Application entrypoint ////////////////////////////////////

	public static function main()
	{
		if(Application.Instance.Config.Development)
		{
			// Run the haXigniter unit tests.
			new haxigniter.unittests.TestRunner();
		}
		
		Application.Instance.Run(Url.Segments);
	}
	
	/////////////////////////////////////////////////////////////////
	
	public function new() {}
	
	public function Run(uriSegments : Array<String>) : Void
	{
		var controllerClass : String = (uriSegments[0] == null) ? Application.defaultController : uriSegments[0];
		var controllerMethod : String = (uriSegments[1] == null) ? Application.defaultMethod : uriSegments[1];

		controllerClass = Application.defaultNamespace + '.' + controllerClass.substr(0, 1).toUpperCase() + controllerClass.substr(1);
		
		// Instantiate a controller with this class name.
		var classType : Class<Dynamic> = Type.resolveClass(controllerClass);
		if(classType == null)
			throw new ControllerException(controllerClass + ' not found. (Is it defined in config/Controllers.hx?)');
		
		// TODO: Controller arguments?
		this.controller = cast Type.createInstance(classType, []);
		
		var method : Dynamic = Reflect.field(this.controller, controllerMethod);
		if(method == null)
			throw new ControllerException(controllerClass + ' method "' + controllerMethod + '" not found.');

		// Typecast the arguments.
		var arguments : Array<Dynamic> = this.typecastArguments(classType, controllerMethod, uriSegments.slice(2));		

		// Execute the controller class with the method specified, and the arguments.
		Reflect.callMethod(this.controller, method, arguments);

		// Clean up controller after it's done.
		this.cleanup();
	}
	
	private function cleanup()
	{
		// Close database connection
		if(this.controller.DB != null)
			this.controller.DB.Close();
			
		// TODO: Save session? (Hopefully not)
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
			if(method.opt && arguments[c] == '')
			{
				++c;
				output.push(null);
			}
			else
			{
				// The methods come in the same order as the arguments, so match each argument with a method type.
				output.push(TypeFactory.CreateType(method.type, arguments[c++]));
			}
		}

		return output;		
	}
}