package haxigniter.types;

import haxigniter.libraries.Debug;
import haxigniter.exceptions.Exception;

/**
* This file contains all special classes that transforms input data from the user to
* well-formed, typecased types and classes. The work is done in the class WebTypes.
*/

class DbID
{
	public var toInt(getIntValue, null) : Int;
	private var intValue : Int;
	private function getIntValue() { return intValue; }
	
	public function new(input : String)
	{
		var intValue : Int = Std.parseInt(input);

		if(intValue == null || intValue <= 0)
			throw new TypeException(Type.getClassName(Type.getClass(this)), input);
		
		this.intValue = intValue;
	}
}

class TypeFactory
{
	public static var ArrayDelimiter : String = '-';
	
	public static function CreateType(typeString : String, value : String) : Class<Dynamic>
	{
		// If output is null at the end, an error will be thrown.
		var output : Dynamic = null;
		
		//Debug.trace('[WebTypeFactory] Creating type: ' + typeString);
		
		var typeParam = splitType(typeString);
		
		switch(typeParam[0])
		{
			///// Primitive types ///////////////////////////////////
			
			case 'Int':
				output = Std.parseInt(value);

			case 'Float':
				output = Std.parseFloat(value);
			
			case 'String':
				output = value;

			case 'Array', 'List':
				// NOTE: How to make the instance with a type parameter?
				// NOTE: Right now only one type parameter is supported!
				output = Type.createInstance(Type.resolveClass(typeParam[0]), []);
				
				var isArray = typeParam[0] == 'Array';

				for(val in value.split(ArrayDelimiter))
				{
					var newType = CreateType(typeParam[1], val);
					
					if(isArray)
						output.push(newType);
					else
						output.add(newType);
				}
			
			/////////////////////////////////////////////////////////
			
			default:
				// Other types will be created by reflection with the string value as argument.
				// It's up to those classes to determine if the value is legal or not.
				var classType = Type.resolveClass(typeString);
				if(classType == null)
					throw new Exception('[WebTypeFactory] Type not found: ' + typeString);
				
				output = Type.createInstance(classType, [value]);
		}

		if(output == null)
			throw new TypeException(typeString, value);

		//Debug.trace('Adding output: ' + output + ' (' + Type.typeof(output) + ')');

		return output;
	}
	
	private static function splitType(typeString : String) : Array<String>
	{
		var typeParam = typeString.indexOf('<');
		
		if(typeParam == -1)
			return [typeString, null];
		
		var mainType = typeString.substr(0, typeParam);
		
		var typeParameter = typeString.substr(typeString.indexOf('<') + 1);
		typeParameter = typeParameter.substr(0, typeParameter.length - 1);		
		
		return [mainType, typeParameter];
	}
}

class TypeException extends Exception
{
	public var ClassName(getClassName, null) : String;
	private var className : String;
	private function getClassName() { return this.className; }

	public var Value(getValue, null) : String;
	private var value : String;
	private function getValue() { return this.value; }
	
	public function new(className : String, value : String)
	{
		this.className = className;
		this.value = value;
		
		super('Invalid value for ' + className + ': "' + value + '"');
	}
}