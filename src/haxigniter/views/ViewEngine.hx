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
	public var templatePath : String;
	public var compiledPath : String;
	
	private function new(templatePath : String, compiledPath : String)
	{
		this.templatePath = templatePath;
		this.compiledPath = compiledPath;
	}
	
	public function assign(name : String, value : Dynamic) : Void
	{
		throw 'Assign() must be implemented in an inherited class.';
	}
	
	public function clearAssign(name : String) : Bool
	{
		throw 'ClearAssign() must be implemented in an inherited class.';
		return null;
	}
	
	public function render(fileName : String) : String
	{
		throw 'Render() must be implemented in an inherited class.';
		return null;
	}
	
	public function display(fileName : String) : Void
	{
		php.Lib.print(this.render(fileName));
	}
}
