package haxigniter.views;

import haxigniter.libraries.Server;

class ViewEngine
{
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