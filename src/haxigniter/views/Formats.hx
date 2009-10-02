package haxigniter.views;

import haxigniter.libraries.Url;

#if php
import php.Lib;
#elseif neko
import neko.Lib;
#end

import haxigniter.Application;

/**
 * This is used to render various formats when requested
 * 
 * render(format : Allowed, app_formats : Hash<Dynamic>) : String
 * 
 */

//enum Allowed{ xml, rss }

class Formats
{
	public static var allowed_types:Array<String> = [ 'xml', 'rss' ];
	
	public static function allow(format : String) : Bool
	{
		for (t in allowed_types){
			if(format == t) return true;
		}
		return false;
	}
	public static function render(format : String, app_formats : Hash<Dynamic>) : String
	{
		// i think this causes a lot of issues if the renderer doesn't exist :/
		// var renderer = Type.createInstance(Type.resolveClass("RenderFormat_"+format),[]);
		var renderer = switch format{
			case "xml":
				new RenderFormat_xml();
			case "rss":
				new RenderFormat_xml();
		}
		
		try{
			return renderer.out(app_formats);
		}catch(e:php.Exception){
			Application.log("Uri.format ." + format + " requested, something went wrong rendering " + "RenderFormat_"+format);
			return '';
		}
	}
}
