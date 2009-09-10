package haxigniter.libraries;

import haxigniter.libraries.Application;

import haxigniter.rtti.RttiUtil;
import haxigniter.types.TypeFactory;
import haxigniter.views.ViewEngine;

import haxigniter.libraries.Database;

import haxigniter.application.config.Config;
import haxigniter.application.config.Controllers;
import haxigniter.application.config.Database;

class ControllerException extends haxigniter.exceptions.Exception {}

class Controller implements haxe.rtti.Infos
{
	public static var DefaultController : String = 'start';
	public static var DefaultMethod : String = 'index';
	
	private static var namespace : String = 'haxigniter.application.controllers';

	public var Config(getConfig, null) : Config;
	private function getConfig() : Config { return haxigniter.libraries.Application.Instance.Config; }

	public var View(getView, null) : ViewEngine;
	private function getView() : ViewEngine { return haxigniter.libraries.Application.Instance.View; }

	public var DB(getDB, null) : DatabaseConnection;
	private function getDB() : DatabaseConnection { return haxigniter.libraries.Application.Instance.DB; }

	public static function Run(uriSegments : Array<String>) : Void
	{
		var controllerClass : String = (uriSegments[0] == null) ? Controller.DefaultController : uriSegments[0];
		var controllerMethod : String = (uriSegments[1] == null) ? Controller.DefaultMethod : uriSegments[1];

		controllerClass = Controller.namespace + '.' + controllerClass.substr(0, 1).toUpperCase() + controllerClass.substr(1);
		
		// Instantiate a controller with this class name.
		var classType : Class<Dynamic> = Type.resolveClass(controllerClass);
		if(classType == null)
			throw new ControllerException(controllerClass + ' not found. (Is it defined in config/Controllers.hx?)');
		
		// TODO: Controller arguments?
		var obj : Dynamic = Type.createInstance(classType, []);
		
		var method : Dynamic = Reflect.field(obj, controllerMethod);
		if(method == null)
			throw new ControllerException(controllerClass + ' method "' + controllerMethod + '" not found.');

		// Typecast the arguments.
		var arguments : Array<Dynamic> = Controller.typecastArguments(classType, controllerMethod, uriSegments.slice(2));		

		// Execute the controller class with the method specified, and the arguments.
		Reflect.callMethod(obj, method, arguments);

		// Clean up controller after it's done.
		cleanupController(obj);
	}
	
	private static function cleanupController(controller : Controller)
	{
		// Close database connection
		if(controller.DB != null)
			controller.DB.Close();
	}
	
	/**
	* Cast arguments to controller (from Uri) to correct type, throwing TypeException if typecast fails.
	*/
	private static function typecastArguments(classType : Class<Dynamic>, classMethod : String, arguments : Array<String>) : Array<Dynamic>
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