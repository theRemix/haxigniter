package haxigniter.application.controllers;

import haxigniter.types.TypeFactory;
import haxigniter.application.models.ItemsModel;
import php.Lib;

class Start extends haxigniter.libraries.RestController
{
	public function update(id : DbID, posted : Hash<String>)
	{
		trace('Update '+id+'<br>');
		this.trace(posted);
	}

	public function create(posted : Hash<String>)
	{
		trace('Create<br>');
		this.trace(posted);
	}

	public function destroy(id : DbID)
	{
		trace('Destroy ' + id.toInt());
	}

	public function edit(id : DbID)
	{
		trace('Edit ' + id.toInt());
	}

	public function show(id : DbID)
	{
		trace('SHOW ME ' + id.toInt());
	}
	
	public function make()
	{
		Lib.print('make a new one.');
	}
	
	public function index()
	{
		this.view.assign('id', 12345);
		this.view.assign('application', 'haXigniter');
		this.view.assign('link', haxigniter.libraries.Url.siteUrl());
		
		this.view.display('start/index.mtt');
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

	#if php
	public function phpinfo()
	{
		if(config.development)
			untyped __php__("phpinfo();");
	}
	#end
}
