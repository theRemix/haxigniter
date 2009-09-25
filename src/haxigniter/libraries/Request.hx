package haxigniter.libraries;

import Type;
import haxigniter.types.TypeFactory;
import haxigniter.rtti.RttiUtil;
import haxigniter.libraries.Controller;
import haxigniter.libraries.RestController;

#if php
import php.Web;
#elseif neko
import neko.Web;
#end

class RequestException extends haxigniter.exceptions.Exception {}
class NotFoundException extends haxigniter.exceptions.Exception {}

class Request
{
	public static var defaultController : String = 'start';
	public static var defaultMethod: String = 'index';
	
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
		var controller : Controller = createController(uriSegments);
		
		if(Std.is(controller, RestController))
			return Request.restfulController(controller, uriSegments);
		else if(Std.is(controller, CustomRequest))
			return Request.customController(controller, uriSegments);
		else
			return Request.standardController(controller, uriSegments);
	}
		
	/////////////////////////////////////////////////////////////////

	private static function standardController(controller : Controller, uriSegments : Array<String>) : Dynamic
	{
		var controllerType = Type.getClass(controller);
		var controllerMethod : String = (uriSegments[1] == null) ? Request.defaultMethod : uriSegments[1];

		var method : Dynamic = Reflect.field(controller, controllerMethod);
		if(method == null)
			throw new NotFoundException(controllerType + ' method "' + controllerMethod + '" not found.');

		// Typecast the arguments.
		var arguments : Array<Dynamic> = typecastArguments(controllerType, controllerMethod, uriSegments.slice(2));
		
		return Reflect.callMethod(controller, method, arguments);
	}

	private static function restfulController(controller : Controller, uriSegments : Array<String>) : Dynamic
	{
		var action : String = null;
		var args : Array<Dynamic> = [];
		var typecastId = false;
		
		// TODO: Multiple languages for reserved keywords
		if(Web.getMethod() == 'GET')
		{
			if(uriSegments.length <= 1)
				action = 'index';
			else if(uriSegments[1] == 'new')
				action = 'make'; // Sorry, cannot use new.
			else
			{
				if(uriSegments[2] == 'edit')
					action = 'edit';
				else if(uriSegments[2] == 'delete')
					action = 'destroy';
				else
				{
					// TODO: Catch all or throw exception on extra arguments?
					action = 'show';
				}

				// Id is the only argument.
				args.push(uriSegments[1]);
				
				typecastId = true;
			}
		}
		else if(Web.getMethod() == 'POST')
		{
			if(uriSegments.length <= 1)
			{
				action = 'create';
				args.push(Web.getParams());
			}
			else
			{
				action = 'update';
				args.push(uriSegments[1]);
				args.push(Web.getParams());
				
				typecastId = true;
			}
		}
		else
		{
			throw new RequestException('Unsupported HTTP method: ' + Web.getMethod());
		}
		
		var controllerType = Type.getClass(controller);
		
		var method : Dynamic = Reflect.field(controller, action);
		if(method == null)
			throw new NotFoundException(controllerType + ' RESTful action "' + action + '" not found.');

		if(typecastId)
		{
			// Typecast the first argument.
			var methodArgs = RttiUtil.getMethod(action, controllerType);
			args[0] = TypeFactory.createType(methodArgs.first().type, args[0]);
		}
		
		return Reflect.callMethod(controller, method, args);
	}

	private static function customController(controller : Controller, uriSegments : Array<String>) : Dynamic
	{
		// Simple, since the controller handles everything.
		var custom = cast(controller, CustomRequest);
		
		return custom.customRequest(uriSegments);
	}

	/////////////////////////////////////////////////////////////////
	
	private static function createController(uriSegments : Array<String>) : Controller
	{
		var controllerClass : String = (uriSegments[0] == null || uriSegments[0] == '') ? defaultController : uriSegments[0];
		controllerClass = defaultNamespace + '.' + controllerClass.substr(0, 1).toUpperCase() + controllerClass.substr(1);
		
		// Instantiate a controller with this class name.
		var classType : Class<Dynamic> = Type.resolveClass(controllerClass);
		if(classType == null)
			throw new NotFoundException(controllerClass + ' not found. (Is it defined in application/config/Controllers.hx?)');
		
		// TODO: Controller arguments?
		return cast Type.createInstance(classType, []);
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
