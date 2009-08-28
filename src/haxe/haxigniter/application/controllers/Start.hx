package haxigniter.application.controllers;

import haxigniter.types.WebTypes;

class Start extends haxigniter.libraries.Controller
{
	public var test : Bool;
	
	public function index(id : DbID, name : Int)
	{
		trace(id.toInt);
		
		//trace(Type.typeof(id));
		//trace('<br>Very nice:' + id);
	}

	public function phpinfo()
	{
		untyped __php__("phpinfo();");
	}
}