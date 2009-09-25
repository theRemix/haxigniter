package haxigniter.libraries;

import Type;
import haxigniter.types.TypeFactory;
import haxigniter.rtti.RttiUtil;
import haxigniter.libraries.Controller;

class NotFoundException extends haxigniter.exceptions.Exception {}

class Request
{
	private static var defaultController : String = 'start';
	private static var defaultMethod : String = 'index';
	
	private static var defaultNamespace : String = 'haxigniter.application.controllers';

	public static function fromString(request : String) : Dynamic
	{
		if(StringTools.startsWith(request, '/'))
			request = request.substr(1);

		if(StringTools.endsWith(request, '/'))
			request = request.substr(0, request.length - 1);
		
		return fromArray(request.split('/'));
	}
	
	public static function fromArray(uriSegments : Array<String>) : Dynamic
	{
		var controllerClass : String = (uriSegments[0] == null || uriSegments[0] == '') ? defaultController : uriSegments[0];
		var controllerMethod : String = (uriSegments[1] == null) ? defaultMethod : uriSegments[1];
		
		var controller : Controller;

		controllerClass = defaultNamespace + '.' + controllerClass.substr(0, 1).toUpperCase() + controllerClass.substr(1);
		
		// Instantiate a controller with this class name.
		var classType : Class<Dynamic> = Type.resolveClass(controllerClass);
		if(classType == null)
			throw new NotFoundException(controllerClass + ' not found. (Is it defined in application/config/Controllers.hx?)');
		
		// TODO: Controller arguments?
		controller = cast Type.createInstance(classType, []);

		var method : Dynamic = Reflect.field(controller, controllerMethod);
		if(method == null)
			throw new NotFoundException(controllerClass + ' method "' + controllerMethod + '" not found.');

		// Typecast the arguments.
		var arguments : Array<Dynamic> = typecastArguments(classType, controllerMethod, uriSegments.slice(2));
		
		return Reflect.callMethod(controller, method, arguments);
	}
		
	/////////////////////////////////////////////////////////////////
	
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
