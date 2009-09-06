package haxigniter;

// Main configuration file, the other config files are usually loaded by the 
// respective library.
import haxigniter.application.config.Config;

// TODO: Unit tests with autorun
import haxigniter.unit.TestCase2;

import haxigniter.libraries.Uri;
import haxigniter.libraries.Controller;

class Index
{
	public static function main()
	{
		if(Config.Instance.Development)
		{
			// Run the haXigniter unit tests.
			new haxigniter.unittests.TestRunner();
		}
		
		Controller.Run(Uri.Segments);
	}	
}