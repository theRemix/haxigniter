package haxigniter.views;

#if php
import php.Lib;
#elseif neko
import neko.Lib;
#end

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
	
	private function new(templatePath : String = null, compiledPath : String = null)
	{
		if(templatePath == null)
			this.templatePath = haxigniter.application.config.Config.instance().viewPath;
		else
			this.templatePath = templatePath;
			
		if(compiledPath == null)
			this.compiledPath = haxigniter.application.config.Config.instance().cachePath;
		else
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
		Lib.print(this.render(fileName));
	}
}
