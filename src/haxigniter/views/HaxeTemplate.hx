package haxigniter.views;

class HaxeTemplateVars
{
	public function new() {}
}

class HaxeTemplate implements haxigniter.views.IViewEngine
{
	private var templateVars : HaxeTemplateVars;
	
	public function new()
	{
		this.templateVars = new HaxeTemplateVars();
	}
	
	public function Assign(name : String, value : Dynamic) : Void
	{
		Reflect.setField(this.templateVars, name, value);
	}
	
	public function ClearAssign(name : String) : Bool
	{
		return Reflect.deleteField(this.templateVars, name);
	}
	
	public function Render(content : String) : String
	{
        var t = new haxe.Template(content);
        
		return t.execute(this.templateVars);
	}
	
	public function RenderFile(fileName : String) : String
	{
		var content = php.io.File.getContent(fileName);
        var t = new haxe.Template(content);

        return t.execute(this.templateVars);
	}
}