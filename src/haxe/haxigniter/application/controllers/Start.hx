package haxigniter.application.controllers;

import haxigniter.libraries.Debug;
import haxigniter.types.TypeFactory;

class Start extends haxigniter.libraries.Controller
{
	public var test : Bool;
	
	public function index(?id : Int = 5)
	{
		Debug.trace(id);
		//trace(Type.typeof(id));
		//trace('<br>Very nice:' + id);
	}

	public function phpinfo()
	{
		untyped __php__("phpinfo();");
	}
}