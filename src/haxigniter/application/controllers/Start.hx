package haxigniter.application.controllers;
import haxe.Firebug;
import php.db.ResultSet;
import php.Web;

import haxigniter.application.external.PHPMailer;

class Start extends haxigniter.libraries.Controller
{
	public function index(?id : Int)
	{
		var mail = new PHPMailer(true);
		
		if(id != null)
		{
			this.Session.Age = id;
			this.Session.anything = 'nice';
		}

		var users = new List<Dynamic>();
		users.add( { name: 'Boris', age: this.Session.Age } );
		users.add( { name: 'Doris', age: 15 } );

		Firebug.trace(users);

		this.View.Assign('name', 'Örnsköldsvik');
		this.View.Assign('users', users);

		this.View.Display('start/index.mtt');
		
		return;
		
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
			new haxigniter.application.tests.Integrity().Run();
	}

	public function phpinfo()
	{
		if(Config.Development)
			untyped __php__("phpinfo();");
	}	
}