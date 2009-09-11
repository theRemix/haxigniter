package haxigniter.views;

class TemploVars
{
	public function new() {}
}

class Templo extends haxigniter.views.ViewEngine
{
	private var templateVars : TemploVars;
	
	public function new(templatePath : String, compiledPath : String, ?macros : String = null, ?optimized : Bool = false)
	{
		// super() will set correct variables for TemplatePath and CompiledPath
		super(templatePath, compiledPath);
		
		templo.Loader.BASE_DIR = this.TemplatePath;
		templo.Loader.TMP_DIR = this.CompiledPath;
		templo.Loader.MACROS = macros;
		templo.Loader.OPTIMIZED = optimized;

		this.templateVars = new TemploVars();
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
		var t = new templo.Loader(fileName);
		return t.execute(this.templateVars);
	}
}