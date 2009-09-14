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
		
		templo.Loader.BASE_DIR = this.templatePath;
		templo.Loader.TMP_DIR = this.compiledPath;
		templo.Loader.MACROS = macros;
		templo.Loader.OPTIMIZED = optimized;

		this.templateVars = new TemploVars();
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
		var t = new templo.Loader(fileName);
		return t.execute(this.templateVars);
	}
}
