package haxigniter.types;

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
			throw new WebTypeException(Type.getClass(this), input);
		
		this.intValue = intValue;
	}
}

class WebTypeFactory
{
	public static function CreateType(typeString : String, value : String) : Class<Dynamic>
	{
		var output : Dynamic = null;
		
		//trace('Create type: ' + typeString + '<br>');
		
		switch(typeString)
		{
			case 'Int':
				output = Std.parseInt(value);
				if(output == null)
					throw new WebTypeException(Int, value);

			case 'Float':
				output = Std.parseFloat(value);
				if(output == null)
					throw new WebTypeException(Float, value);
			
			case 'String':
				output = value;
			
			default:
				var classType = Type.resolveClass(typeString);
				if(classType == null)
					throw new Exception('[WebTypeFactory] Type not found: ' + typeString);
				
				output = Type.createInstance(classType, [value]);
		}

		//trace('Adding output: ' + output + ' (' + Type.typeof(output) + ')<br>');

		return output;
	}
}

class WebTypeException extends Exception
{
	public var Type(getType, null) : Class<Dynamic>;
	private var type : Class<Dynamic>;
	private function getType() { return this.type; }

	public var Value(getValue, null) : String;
	private var value : String;
	private function getValue() { return this.value; }
	
	public function new(type : Class<Dynamic>, value : String)
	{
		this.type = type;
		this.value = value;
		
		super('Invalid value for ' + type + ': "' + value + '"');
	}
}