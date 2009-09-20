package haxigniter.views;

import php.NativeArray;
import Type;

class Smarty extends haxigniter.views.ViewEngine
{
	private var smartyEngine : haxigniter.application.external.Smarty;
	
	private var cacheId : String;
	private var cachePath : String;
	
	public function new(templatePath : String, compiledPath : String, ?cachePath : String, ?cacheId : String)
	{
		haxigniter.libraries.Server.requireExternal('smarty/libs/Smarty.class.php');
		
		this.smartyEngine = new haxigniter.application.external.Smarty();

		// super() will set correct variables for templatePath and compiledPath
		super(templatePath, compiledPath);

		this.smartyEngine.template_dir = this.templatePath;
		this.smartyEngine.compile_dir = this.compiledPath;
		
		this.cachePath = cachePath;
		this.cacheId = cacheId;
	}

	private function isIterable(d : Dynamic) : Bool
	{
		return (d != null && (Reflect.hasField(d, 'iterator')));
	}

	private function phpArray(array : Array<Dynamic>) : String
	{
		return 'array(' + Lambda.map(array, this.toPhpValue).join(', ') + ')';
	}

	private function phpAssociativeArray(hash : Hash<Dynamic>) : String
	{
		var output = '';
		for(key in hash.keys())
		{
			output += "'" + key + "'" + ' => ' + toPhpValue(hash.get(key)) + ', ';
		}
		
		if(output.length > 0)
			output = output.substr(0, output.length - 2);
		
		return 'array(' + output + ')';
	}

	private function phpObject(o : Dynamic) : String
	{
		trace(Reflect.fields(o));
		var output = '';
		for(key in Reflect.fields(o))
		{
			trace(key + '<br>');
			output += "'" + key + "'" + ' => ' + toPhpValue(Reflect.field(o, key)) + ', ';
		}
		
		if(output.length > 0)
			output = output.substr(0, output.length - 2);
		
		return 'array(' + output + ')';
	}
	
	private function toPhpValue(value : Dynamic) : String
	{
		if(value == null)
			return 'null';
		else if(Std.is(value, String))
			return "'" + StringTools.replace(value, "'", "\\'") + "'";
		else if(Std.is(value, Int) || Std.is(value, Float) || (Std.is(value, Bool)))
			return Std.string(value);
		else if(Std.is(value, Hash))
			return this.phpAssociativeArray(value);
		else if(Std.is(value, Array) || Std.is(value, List))
			return this.phpArray(value);
		else
			return this.phpObject(value);
	}

	public override function assign(name : String, value : Dynamic) : Void
	{
		//haxigniter.libraries.Debug.trace(this.toPhpValue(value));

		var __smarty : Dynamic = value;
		//untyped __call__('eval', '$__smarty = ' + this.toPhpValue(value) + ';');
		
		this.smartyEngine.assign(name, __smarty);
	}
	
	public override function clearAssign(name : String) : Bool
	{
		var exists = this.smartyEngine.get_template_vars(name) != null;
		this.smartyEngine.clear_assign(name);
		
		return exists;
	}

	public override function render(fileName : String) : String
	{
		untyped __call__('error_reporting', 0);
		return this.smartyEngine.fetch(fileName, this.cacheId);
	}
}
