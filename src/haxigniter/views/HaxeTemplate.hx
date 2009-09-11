package haxigniter.views;

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
	
	public override function Assign(name : String, value : Dynamic) : Void
	{
		Reflect.setField(this.templateVars, name, value);
	}
	
	public override function ClearAssign(name : String) : Bool
	{
		return Reflect.deleteField(this.templateVars, name);
	}
	
	public override function Render(fileName : String) : String
	{
		fileName = this.TemplatePath + fileName;
		
		var content = php.io.File.getContent(fileName);
        var t = new haxe.Template(content);
		
		return t.execute(this.templateVars);
	}
}