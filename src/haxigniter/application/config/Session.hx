package haxigniter.application.config;

class Session extends haxigniter.libraries.Session 
{
	public var Name : String;
	public var Age : Int;

	// For initializing the instance variables, if needed.
	public function new()
	{	
		super(); // This is required, do not remove.
	}
}