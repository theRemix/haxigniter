
class EReg2 extends EReg
{
	private static var quoteMetaChars : String = '.\\+*?[^]($)';
	
	/**
	* Taken from the php function quotemeta().
	* Escapes all regexp meta characters in a string with a backslash.
	* Note that front slash is not escaped!
	*/
	public static function QuoteMeta(str : String) : String
	{
		for(i in 0...EReg2.quoteMetaChars.length)
		{
			var char = EReg2.quoteMetaChars.charAt(i);
			str = StringTools.replace(str, char, '\\' + char);
		}
		
		return str;
	}
}