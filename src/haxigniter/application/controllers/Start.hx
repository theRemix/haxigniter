package haxigniter.application.controllers;

import haxe.Template;
import haxigniter.libraries.Debug;
import haxigniter.libraries.Server;
import haxigniter.types.TypeFactory;

class Start extends haxigniter.libraries.Controller
{
	public var test : Bool;
	
	public function index(id : Int)
	{
		var template : String = 'The habitants of <em>::name::</em> are : <ul>::foreach users::<li>::name:: - ::if (age > 18)::Grownup::elseif (age <= 2)::Baby::else::Young::end::</li>::end::</ul>';
		/*
		var input = { name : 'Turvia', users: {
			{ name: 'Boris', age: 40 }, 
			{ name: 'Doris', age: 15 },
			{ name: 'Snoris', age: 1}
		}};
		*/

		var users = new List<Dynamic>();
		users.add( { name: 'Boris', age: 40 } );
		users.add( { name: 'Doris', age: 15 } );

		this.View.Assign('name', 'Turvia');
		this.View.Assign('users', users);

		this.View.Display('start/index.htt');
		
		//Debug.trace(php.Web.getHostName());
		//Debug.trace(haxigniter.application.config.Config.Instance.BaseUrl);
		//Debug.trace(this.Config.Development);		
		//Debug.trace(id);
	}

	public function phpinfo()
	{
		untyped __php__("phpinfo();");		
	}
}