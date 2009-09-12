package haxigniter.application.controllers;

class Dev extends haxigniter.libraries.Controller
{
	public function phpinfo()
	{
		if(this.Config.Development)
			untyped __php__("phpinfo();");
	}	
}