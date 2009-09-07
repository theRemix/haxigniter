package haxigniter.application.controllers;

import haxigniter.libraries.Debug;
import haxigniter.types.TypeFactory;

class Start extends haxigniter.libraries.Controller
{
	public var test : Bool;
	
	public function index(id : Array<Int>)
	{
		Debug.trace(php.Web.getHostName());
		
		//Debug.trace(haxigniter.application.config.Config.Instance().BaseUrl);
		Debug.trace(this.Config.Development);
		
		Debug.trace(id);
		//trace(Type.typeof(id));
		//trace('<br>Very nice:' + id);
	}

	public function phpinfo()
	{
		untyped __php__("phpinfo();");
	}
}