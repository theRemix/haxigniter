package haxigniter.application.controllers;

import haxigniter.types.TypeFactory;
import haxigniter.application.models.ItemsModel;
import php.Lib;

class Smart implements Dynamic { public function new() { } }

class Start extends haxigniter.libraries.Controller
{
	public function new() {}
	
	public function index(?id : DbID)
	{
		if(id != null)
		{
			this.session.age = id.toInt();
			this.session.anything = 'nice';

			var item : Dynamic = ItemsModel.item(id);
			this.trace(item);
		}
		
		var users = new List<Dynamic>();
		var u1 = new Smart();
		var u2 = new Smart();
		
		var me = ['very', 'nice', 1, 2, 3];
		
		u1.name = 'Boris';
		u1.age = 20;

		/*
		for(field in Reflect.fields(u1))
		{
			trace(Reflect.field(u1, field));
		}
		*/

		u2.name = 'Doris';
		u2.age = 15;

		users.add(u1);
		users.add(u2);
		
		this.view.assign('name', 'Hällnäs');
		this.view.assign('users', users);
		this.view.assign('who', me);

		this.view.display('start/index.tpl');
		
		return;
		
		/*
		var users = new List<Dynamic>();
		users.add( { name: 'Boris', age: 40 } );
		users.add( { name: 'Doris', age: 15 } );

		this.View.assign('name', 'Turvia');
		this.View.assign('users', users);
		*/

		//this.View.display('start/index.htt');
		
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
