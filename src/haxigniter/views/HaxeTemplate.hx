package haxigniter.views;

class HaxeTemplate implements haxigniter.views.IViewEngine
{
	private var templateVars : Hash<Dynamic>;
	
	public function new()
	{
		this.templateVars = new Hash<Dynamic>();
	}
	
	public function Assign(name : String, value : Dynamic) : Void
	{
		this.templateVars.set(name, value);
	}
	
	public function ClearAssign(name : String) : Bool
	{
		return this.templateVars.remove(name);
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