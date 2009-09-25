package haxigniter.application.controllers;

import haxigniter.libraries.Server;

class Dev extends haxigniter.libraries.Controller
{
	/**
	 * Run integrity tests, good when rolling out application for the first time.
	 * @param	password default password is 'password'. Please change it.
	 */
	public function integrity(password = '')
	{
		if(config.development || password == 'password')
			new haxigniter.application.tests.Integrity().run();
		else
		{
			// Act like there is nothing here.
			Server.error404();
		}
	}

	#if php
	public function phpinfo()
	{
		if(config.development)
			untyped __php__("phpinfo();");
		else
			Server.error404();
	}
	#end
}
