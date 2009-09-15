package haxigniter.views;

#if php
import php.io.File;
#elseif neko
import neko.io.File;
#end

class HaxeTemplateVars
{
	public function new() {}
}

class HaxeTemplate extends haxigniter.views.ViewEngine
{
	private var templateVars : HaxeTemplateVars;
	
	public function new(templatePath : String = null)
	{
		super(templatePath, null);
		this.templateVars = new HaxeTemplateVars();
	}
	
	public override function assign(name : String, value : Dynamic) : Void
	{
		Reflect.setField(this.templateVars, name, value);
	}
	
	public override function clearAssign(name : String) : Bool
	{
		return Reflect.deleteField(this.templateVars, name);
	}
	
	public override function render(fileName : String) : String
	{
		fileName = this.templatePath + fileName;
		
		var content = File.getContent(fileName);
        var t = new haxe.Template(content);
		
		return t.execute(this.templateVars);
	}
}
