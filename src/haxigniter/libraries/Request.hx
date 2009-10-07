package haxigniter.libraries;

import Type;
import haxigniter.types.TypeFactory;
import haxigniter.rtti.RttiUtil;
import haxigniter.libraries.Controller;
import haxigniter.libraries.RestController;

class RequestException extends haxigniter.exceptions.Exception {}
class NotFoundException extends haxigniter.exceptions.Exception {}

class Request
{
	private static var config = haxigniter.application.config.Config.instance();	
	public static var defaultPackage : String = 'haxigniter.application.controllers';

	public static function fromString(request : String, ?method : String, ?query : Hash<String>) : Dynamic
	{
		if(StringTools.startsWith(request, '/'))
			request = request.substr(1);

		if(StringTools.endsWith(request, '/'))
			request = request.substr(0, request.length - 1);
		
		return fromArray(request.split('/'), method, query);
	}
	
	public static function fromArray(uriSegments : Array<String>, ?method : String, ?query : Hash<String>) : Dynamic
	{
		var controller : Controller = createController(uriSegments);
		
		if(Std.is(controller, RestController))
			return Request.restfulController(controller, uriSegments, method, query);
		else if(Std.is(controller, CustomRequest))
			return Request.customController(controller, uriSegments, method, query);
		else
			return Request.standardController(controller, uriSegments, method, query);
	}
		
	/////////////////////////////////////////////////////////////////

	private static function standardController(controller : Controller, uriSegments : Array<String>, method : String, query : Hash<String>) : Dynamic
	{
		var controllerType = Type.getClass(controller);
		var controllerMethod : String = (uriSegments[1] == null) ? config.defaultAction : uriSegments[1];

		var callMethod : Dynamic = Reflect.field(controller, controllerMethod);
		if(callMethod == null)
			throw new NotFoundException(controllerType + ' method "' + controllerMethod + '" not found.');

		// Typecast the arguments.
		var arguments : Array<Dynamic> = typecastArguments(controllerType, controllerMethod, uriSegments.slice(2));
		
		return Reflect.callMethod(controller, callMethod, arguments);
	}

	private static function restfulController(controller : Controller, uriSegments : Array<String>, method : String, query : Hash<String>) : Dynamic
	{
		var action : String = null;
		var args : Array<Dynamic> = [];
		var typecastId = false;

		var controllerType = Type.getClass(controller);
		var callMethod : Dynamic;
		
		// TODO: Multiple languages for reserved keywords
		if(method == 'GET')
		{
			// Start of extra arguments in the request
			var extraArgsPos : Int = null;
			
			// Start of extra arguments in the method
			var argOffset : Int = null;

			if(uriSegments.length <= 1)
			{
				action = 'index';
			}
			else if(uriSegments[1] == 'new')
			{
				action = 'make'; // Sorry, cannot use new.
				extraArgsPos = 2;
				argOffset = 0;
			}
			else
			{
				if(uriSegments[2] == 'edit')
				{
					action = 'edit';
					extraArgsPos = 3;
				}
				else
				{
					action = 'show';
					extraArgsPos = 2;
				}
				
				// Id is the only argument.
				args.push(uriSegments[1]);
				argOffset = 1;
				typecastId = true;
			}

			callMethod = Reflect.field(controller, action);
			if(callMethod == null)
				throw new NotFoundException(controllerType + ' REST-action "' + action + '" not found.');

			// Add extra arguments if the action allows.
			if(extraArgsPos != null)
			{
				//haxigniter.Application.trace('--- Request: ' + uriSegments);
				//haxigniter.Application.trace('Extra args: ' + uriSegments.slice(extraArgsPos));
				
				// Typecast the extra arguments and add them to the action.
				var extraArguments : Array<Dynamic> = typecastArguments(Type.getClass(controller), action, uriSegments.slice(extraArgsPos), argOffset);

				args = args.concat(extraArguments);
				
				//haxigniter.Application.trace('Typed: ' + extraArguments);
				//haxigniter.Application.trace('Output: ' + args);
			}
		}
		else if(method == 'POST')
		{
			if(query == null)
				query = new Hash<String>();
			
			if(uriSegments.length <= 1)
			{
				action = 'create';
				args.push(query);
			}
			else if(uriSegments[2] == 'delete')
			{
				action = 'destroy';

				args.push(uriSegments[1]);
				typecastId = true;
			}
			else
			{
				action = 'update';

				args.push(uriSegments[1]);
				args.push(query);
				typecastId = true;
			}

			callMethod = Reflect.field(controller, action);
			if(callMethod == null)
				throw new NotFoundException(controllerType + ' REST-action "' + action + '" not found.');
		}
		else
		{
			throw new RequestException('Unsupported HTTP method: ' + method);
		}
		
		if(typecastId)
		{
			// Typecast the first argument.
			var methodArgs = RttiUtil.getMethod(action, controllerType);
			args[0] = TypeFactory.createType(methodArgs.first().type, args[0]);
		}
		
		return Reflect.callMethod(controller, callMethod, args);
	}

	private static function customController(controller : Controller, uriSegments : Array<String>, method : String, query : Hash<String>) : Dynamic
	{
		// Simple, since the controller handles everything.
		var custom = cast(controller, CustomRequest);
		
		return custom.customRequest(uriSegments, method, query);
	}

	/////////////////////////////////////////////////////////////////
	
	private static function createController(uriSegments : Array<String>) : Controller
	{
		var controllerClass : String = (uriSegments[0] == null || uriSegments[0] == '') ? config.defaultController : uriSegments[0];
		controllerClass = defaultPackage + '.' + controllerClass.substr(0, 1).toUpperCase() + controllerClass.substr(1);
		
		// Instantiate a controller with this class name.
		var classType : Class<Dynamic> = Type.resolveClass(controllerClass);
		if(classType == null)
			throw new NotFoundException(controllerClass + ' not found. (Is it defined in application/config/Controllers.hx?)');

		// TODO: Controller arguments?
		var controller = cast Type.createInstance(classType, []);
		haxigniter.Application.instance().controller = controller;
		return controller;
	}
	
	/**
	* Cast arguments to controller (from Uri) to correct type, throwing TypeException if typecast fails.
	*/
	private static function typecastArguments(classType : Class<Dynamic>, classMethod : String, arguments : Array<String>, ?offset = 0) : Array<Dynamic>
	{
		var output : Array<Dynamic> = [];		
		var c = 0;
		
		for(method in RttiUtil.getMethod(classMethod, classType))
		{
			// The RestController only uses a range of the argument array, so an offset
			// can be specified to adjust the method arguments to start from.
			if(offset > 0)
			{
				--offset;
				continue;
			}
			
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
