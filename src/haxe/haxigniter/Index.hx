package haxigniter;

import haxigniter.libraries.Uri;
import haxigniter.libraries.Controller;

class Index
{
	public static function main()
	{
		Controller.Run(Uri.Segments);
	}	
}