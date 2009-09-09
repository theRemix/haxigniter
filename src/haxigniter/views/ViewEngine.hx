package haxigniter.views;

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
	
	private function new(templatePath : String = null)
	{
		// Set default template path if not specified
		if(templatePath == null)
			this.TemplatePath = Server.DocumentRoot + '/lib/haxigniter/application/views/';
		else
			this.TemplatePath = templatePath;
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
	
	public function Render(content : String) : String
	{
		throw 'Render() must be implemented in an inherited class.';
		return null;
	}
	
	public function RenderFile(fileName : String) : String
	{
		if(this.TemplatePath != null)
			fileName = this.TemplatePath + fileName;
		
		var content = php.io.File.getContent(fileName);
		return this.Render(content);
	}
	
	public function Display(fileName : String) : Void
	{
		php.Lib.print(this.RenderFile(fileName));
	}
}