package haxigniter.application.controllers;

//import haxe.Template;

import haxe.Firebug;
import haxigniter.libraries.Debug;
import haxigniter.libraries.Server;
import haxigniter.types.TypeFactory;

import haxigniter.libraries.Url;

import php.db.ResultSet;

class Start extends haxigniter.libraries.Controller
{
	public var test : Bool;
	
	public function index(?id : Int)
	{
		if(id != null)
		{
			this.Session.Age = id;
			this.Session.FlashVar = id;
		}

		/*
		var users = new List<Dynamic>();
		users.add( { name: 'Boris', age: 40 } );
		users.add( { name: 'Doris', age: 15.33 } );

		haxigniter.Application.Log('Testing testing');
		haxigniter.Application.Log(123, DebugLevel.Warning);

		this.View.Assign('name', 'Lurvia');
		this.View.Assign('users', users);

		this.View.Display('start/index.mtt');
		*/
		
		return;
		
		//var template : String = 'The habitants of <em>::name::</em> are : <ul>::foreach users::<li>::name:: - ::if (age > 18)::Grownup::elseif (age <= 2)::Baby::else::Young::end::</li>::end::</ul>';

		/*
		var users = new List<Dynamic>();
		users.add( { name: 'Boris', age: 40 } );
		users.add( { name: 'Doris', age: 15 } );

		this.View.Assign('name', 'Turvia');
		this.View.Assign('users', users);
		*/

		//this.View.Display('start/index.htt');
		
		//Debug.trace(php.Web.getHostName());
		//Debug.trace(this.Config.BaseUrl);
		//Debug.trace(this.Config.Development);		
		//Debug.trace(id);

		/*
		var where = new Hash<Dynamic>();
		var args = new Hash<Dynamic>();
		
		args.set('name', 'haXigniter');
		args.set('sortorder', 0);
		args.set('userid', 'HTTPS');
		
		var result = this.DB.Insert("items", args);
		
		where.set('id', 48);
		var result = this.DB.Delete('items', where, 1);
		
		Debug.trace(result);
		Debug.trace(this.DB.LastQuery);
		
		//php.Lib.print(result.name + ' ' + result.letter + '<br>');
		
		return;
		*/
	}
	
	/**
	 * Run integrity tests, good when rolling out application for the first time.
	 * @param	password default password is 'dev'. Change when deployed.
	 */
	public function integrity(password = '')
	{
		if(Config.Development || password == 'dev')
			new haxigniter.application.libraries.Integrity().Run();
	}
}