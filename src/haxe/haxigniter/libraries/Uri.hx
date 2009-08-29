package haxigniter.libraries;

import haxigniter.application.config.Config;
import php.Web;

class Uri
{
	public static var PermittedUriChars : String = Config.Instance().PermittedUriChars;
	
	public static var Segments(getSegments, null) : Array<String>;
	private static var segments : Array<String>;
	private static function getSegments()
	{
		if(Uri.segments == null)
		{
			var currentUri : String = Web.getURI();
			
			// Segments will be accessed in the controller, so it's safe to do the URI test here.
			if(Uri.PermittedUriChars.length > 0)
				Uri.testValidUri(currentUri);
			
			// TODO: SCRIPT_NAME may cause problems on other systems, watch for it.
			var scriptName : String = untyped __var__('_SERVER', 'SCRIPT_NAME');
			var segmentString : String = currentUri.substr(scriptName.length + 1); // +1 for the ending slash

			// Strip empty segment at the end of the string.
			if(segmentString.charAt(segmentString.length-1) == '/')
				segmentString = segmentString.substr(0, segmentString.length-1);

			Uri.segments = segmentString.length > 0 ? segmentString.split('/') : [];
		}
		
		return Uri.segments;
	}
		
	public static function UriString() : String
	{
		var output : String = Uri.Segments.join('/');
		return output.length > 0 ? '/' + output : '';
	}
	
	private static function testValidUri(uri : String) : Void
	{
		// Build a regexp from the permitted chars and test it.
		// Adding slash at the beginning since it's a part of any valid URI.
		var regexp = '^[/' + EReg2.QuoteMeta(Uri.PermittedUriChars) + ']*$';
		var validUrl = new EReg(regexp, 'i');
		
		if(!validUrl.match(uri))
		{
			// TODO: Localize?
			throw 'The URI you submitted has disallowed characters.';
		}
	}
}