package haxigniter.views;

class RenderFormat_xml implements IFormatRenderer{
	private var output:String;
	private var controller:String;
	public function new(){}
	public function out(obj:Hash<Dynamic>) : String
	{
		php.Web.setHeader("Content-Type","application/xml;charset=UTF-8");
		controller = haxigniter.Application.instance().controller.name;
		
		 // pluralize controller as the root node
		var plural:String = (controller.charAt(controller.length-1) == "s")? controller : controller+'s';
		
		output = '<?xml version="1.0" encoding="UTF-8"?>\r\n';
		output += "<"+plural+">\r\n";
		var o:Dynamic;
		for(o in obj){
			renderXML(o);
		}
		output += "</"+plural+">";
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
		
		//unpluralize
		var single:String = (controller.charAt(controller.length-1) == "s")? controller.substr(0,controller.length-1) : controller;
		
		output += tabs+"<"+single+">\r\n";
		
		if(Reflect.hasField(obj, "iterator")){
			var it:Iterable<Dynamic> = obj;
        	for ( i in it ){
				renderXML( i, level + 1 );
	        }
		}else{
			var it = Reflect.fields(obj);
			for (i in it){
				if(Std.parseInt(i) == null) // don't parse the duplicate integer keys
					output += tabs + "\t" + tag(i, Reflect.field(obj, i)) + "\r\n";
			}
		}
		
		output += tabs+"</"+single+">\r\n";
		
	}
	
	private function tag(name:String,content:String):String
	{
		return "<"+name+">"+content+"</"+name+">";
	}
}