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
			this.session.age = id;
			this.session.anything = 'nice';
		}

		var users = new List<Dynamic>();
		users.add( { name: 'Boris', age: this.session.age } );
		users.add( { name: 'Doris', age: 15 } );

		Firebug.trace(users);

		this.view.assign('name', 'Örnsköldsvik');
		this.view.assign('users', users);

		this.view.display('start/index.mtt');
		
		return;
		
		/*
		var users = new List<Dynamic>();
		users.add( { name: 'Boris', age: 40 } );
		users.add( { name: 'Doris', age: 15 } );

		this.View.assign('name', 'Turvia');
		this.View.assign('users', users);
		*/

		//this.View.display('start/index.htt');
		
		//Debug.trace(php.Web.getHostName());
		//Debug.trace(this.Config.baseUrl);
		//Debug.trace(this.Config.development);		
		//Debug.trace(id);

		/*
		var where = new Hash<Dynamic>();
		var args = new Hash<Dynamic>();
		
		args.set('name', 'haXigniter');
		args.set('sortorder', 0);
		args.set('userid', 'HTTPS');
		
		var result = this.DB.insert("items", args);
		
		where.set('id', 48);
		var result = this.DB.delete('items', where, 1);
		
		Debug.trace(result);
		Debug.trace(this.DB.lastQuery);
		
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
		if(config.development || password == 'dev')
			new haxigniter.application.tests.Integrity().run();
	}

	public function phpinfo()
	{
		if(config.development)
			untyped __php__("phpinfo();");
	}	
}
