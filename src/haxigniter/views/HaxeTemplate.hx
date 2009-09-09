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
		super(templatePath);
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
	
	public override function Render(content : String) : String
	{
        var t = new haxe.Template(content);
        
		return t.execute(this.templateVars);
	}
}