package haxigniter.views;

import haxigniter.Application;
import haxigniter.libraries.Server;

/**
 * This is an abstract class which is the base of the views of haXigniter.
 * The following methods needs to be implemented:
 * 
 * Assign(name : String, value : Dynamic)
 * ClearAssign(name : String)
 * Render(content : String)
 * 
 */
class ViewEngine
{
	// TODO: Caching system for ViewEngine
	public var TemplatePath : String;
	public var CompiledPath : String;
	
	private function new(templatePath : String, compiledPath : String)
	{
		this.TemplatePath = templatePath;
		this.CompiledPath = compiledPath;
	}
	
	public function Assign(name : String, value : Dynamic) : Void
	{
		throw 'Assign() must be implemented in an inherited class.';
	}
	
	public function ClearAssign(name : String) : Bool
	{
		throw 'ClearAssign() must be implemented in an inherited class.';
		return null;
	}
	
	public function Render(fileName : String) : String
	{
		throw 'Render() must be implemented in an inherited class.';
		return null;
	}
	
	public function Display(fileName : String) : Void
	{
		php.Lib.print(this.Render(fileName));
	}
}