package haxigniter.views;

class RenderFormat_xml implements IFormatRenderer{
	private var output:String;
	private var controller:String;
	public function new(){}
	public function out(obj:Hash<Dynamic>) : String
	{
		php.Web.setHeader("Content-Type","application/xml;charset=UTF-8");
		controller = haxigniter.Application.instance().controller.name;
		output = '<?xml version="1.0" encoding="UTF-8"?>\r\n';
		output += "<"+controller+"s>\r\n"; // pluralize controller as the root node
		var o:Dynamic;
		for(o in obj){
			renderXML(o);
		}
		output += "</"+controller+"s>"; // pluralize controller as the root node
		return output;
	}
	
	// deepTrace
	public function renderXML( obj:Dynamic, level:Int = 0 ):Void
	{
		var tabs:String = "";
		var i:Int = 0;
		var l:Int = level;
		for ( i in 0...l){
			tabs += "\t ";
		}
		
		output += tabs+"<"+controller+">\r\n";
		
		if(Reflect.hasField(obj, "iterator")){
			var it:Iterable<Dynamic> = obj;
        	for ( i in it ){
				renderXML( i, level + 1 );
	        }
		}else{
			var it = Reflect.fields(obj);
			for (i in it){
				output += tabs + "\t" + tag(i, Reflect.field(obj, i)) + "\r\n";
			}
		}
		
		output += tabs+"</"+controller+">\r\n";
		
	}
	
	private function tag(name:String,content:String):String
	{
		return "<"+name+">"+content+"</"+name+">";
	}
}