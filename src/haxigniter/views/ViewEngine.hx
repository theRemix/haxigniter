package haxigniter.views;

import haxe.PosInfos;
import haxigniter.libraries.Url;
import haxigniter.views.Formats;

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
 * assign(name : String, value : Dynamic)
 * clearAssign(name : String)
 * render(content : String)
 * 
 * And this var must be set:
 * 
 * templateExtension : String
 * 
 */
class ViewEngine
{
	// TODO: Caching system for ViewEngine
	// TODO: Auto-assigning of variables for each request
	public var templatePath : String;
	public var compiledPath : String;
	
	/**
	 * Template file extension, without dot. Used in displayDefault().
	 */
	public var templateExtension : String;
	
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
	
	public function renderFormat( fileName : String ) : String
	{
		// Controller action does not set the format variables, format.set('xml', posts);
		if(!Application.instance().controller.format.exists(Url.format)){
			Application.log("Uri.format ." + Url.format + " requested with no variables set, fall back to html");
			Url.format = "html";
			display(fileName);
		}
		else if(Formats.allow(Url.format))
		{
			// good, render format
			return Formats.render(Url.format, Application.instance().controller.format.get(Url.format));
		}else{
			// no such format handler, log and fallback to default
			Application.log("Uri.format ." + Url.format + " requested, handled by html template.");
			Url.format = "html";
			display(fileName);
		}
		return '';
	}
	
	public function display(fileName : String) : Void
	{
		if(Url.format == "html")
			Lib.print(this.render(fileName));
		else // skip html templating, go to format template
			Lib.print(this.renderFormat(fileName));
	}
	
	/**
	 * Uses information from the last called method to display a view.
	 * It displays the view "classname/method.EXT" where EXT is templateExtension. All lowercase.
	 * @param	?pos Information about last called method, usually this should be left blank.
	 */
	public function displayDefault(?pos : PosInfos) : Void
	{
		var className = pos.className.substr(pos.className.lastIndexOf('.')+1).toLowerCase();
		this.display(className + '/' + pos.methodName + '.' + this.templateExtension);
	}
}
