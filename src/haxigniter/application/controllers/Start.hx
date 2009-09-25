package haxigniter.application.controllers;

import haxigniter.types.TypeFactory;
import haxigniter.application.models.ItemsModel;
import php.Lib;

class Start extends haxigniter.libraries.Controller
{
	public function new() {}
	
	public function index(?id : Int)
	{
		this.view.assign('id', id);
		this.view.assign('application', 'haXigniter');
		this.view.assign('link', haxigniter.libraries.Url.siteUrl());
		
		this.view.display('start/index.mtt');
	}
	
	public function error()
	{
		Lib.print('What is this!');
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
