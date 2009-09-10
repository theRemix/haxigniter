package haxigniter.libraries; 

class Session implements Dynamic 
{
	// Internal flag for when flash is retrieved
	// It must be static because static vars aren't serialized.
	private static var gotCurrentFlash : Bool = false;
	private static var currentFlash : Dynamic = null;

	private static var namespace = '_haxigniter_';
	private static var flashNamespace = '_flash_';

	public var FlashVar(getFlash, setFlash) : Dynamic;
	private function getFlash()
	{
		// If no flash request is done, get the current flash var and remove it.
		if(!gotCurrentFlash && this.Exists(flashNamespace))
		{
			gotCurrentFlash = true;
			
			Session.currentFlash = this.Get(flashNamespace);
			this.Remove(flashNamespace);
		}
		
		return Session.currentFlash;
	}
	private function setFlash(value : Dynamic)
	{		
		// Need to set gotCurrentFlash here so it's not removed by getFlash() in the same request.
		gotCurrentFlash = true;

		this.Set(flashNamespace, value);

		Session.currentFlash = value;
		return Session.currentFlash;
	}
	
	/**
	* This class is abstract, so constructor is private.
	*/
	private function new() { }

	public function Get(name : String) : Dynamic
	{
		return php.Session.get(namespace + name);
	}

	public function Set(name : String, value : Dynamic) : Void
	{
		php.Session.set(namespace + name, value);
	}

	public function Exists(name : String) : Bool
	{
		return php.Session.exists(namespace + name);
	}

	public function Remove(name : String) : Bool
	{
		var output = this.Exists(name);
		php.Session.remove(namespace + name);
		
		return output;
	}
}