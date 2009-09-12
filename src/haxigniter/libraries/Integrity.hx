package haxigniter.libraries;
import php.FileSystem;
import php.Lib;
import php.Web;

class Integrity
{
	public var TestMethodPrefix : String;
	private var config : haxigniter.libraries.Config;
	
	public function new()
	{
		this.config = haxigniter.Application.Instance.Config;
		this.TestMethodPrefix = 'Test';
	}
	
	public function Run()
	{
		for(field in Type.getInstanceFields(Type.getClass(this)))
		{
			if(StringTools.startsWith(field, this.TestMethodPrefix) && Reflect.isFunction(Reflect.field(this, field)))
				runTest(field);
		}
	}
	
	private function runTest(methodName : String)
	{
		var title = {value: methodName};
		var result : Bool = Reflect.callMethod(this, Reflect.field(this, methodName), [title]);

		Lib.print('<div style="font-family: Verdana; font-size:12px; float:left; display:inline; padding:4px; margin:1px; border:1px solid gray; width:99%;">');
		Lib.print('<div style="float:left; padding:0 3px 0 3px;">' + title.value + '</div>');

		if(result == true)
			Lib.print('<div style="width:70px; float:right; background-color:#2D1; padding:1px 3px 1px 3px; text-align:center;">OK</div>');
		else if(result == null)
			Lib.print('<div style="width:70px; float:right; padding:1px 3px 1px 3px; text-align:center;"><strong>?</strong></div>');
		else
			Lib.print('<div style="width:70px; float:right; background-color:#C12; padding:1px 3px 1px 3px; text-align:center;">FAILED</div>');
		
		Lib.print('</div>');			
		Web.flush();
	}
	
	private function printHeader(text : String)
    {
        Lib.print('<div style="font-family: Verdana; font-size:13px; font-weight:bold; float:left; display:inline; padding:8px 4px 0 4px; margin:1px; border:0; width:99%;">');
        Lib.print('<div style="float:left; padding:0;">' + text + '</div></div>');
		Web.flush();
    }

	private function isWritable(path : String) : Bool
	{
		return untyped __call__('is_writable', path);
	}
	
	/////////////////////////////////////////////////////////////////
	
	public function TestHX1(title : { value : String }) : Bool
	{
		printHeader('[haXigniter] Directory access');
		
		title.value = 'Cache path <b>"' + config.CachePath + '"</b> exists and is writable';
		return this.isWritable(config.CachePath);
	}

	public function TestHX2(title : { value : String }) : Bool
	{
		title.value = 'Log path <b>"' + config.LogPath + '"</b> exists and is writable';
		return this.isWritable(config.LogPath);
	}

	public function TestHX3(title : { value : String }) : Bool
	{
		title.value = 'Session path <b>"' + config.SessionPath + '"</b> exists and is writable';
		return this.isWritable(config.SessionPath);
	}

	public function TestHX4(title : { value : String }) : Bool
	{
		printHeader('[haXigniter] File integrity');

		var htaccess = FileSystem.fullPath(config.ApplicationPath + '../../.htaccess');

		title.value = '<b>"' + htaccess + '"</b> exists to prevent access to haXigniter files';
		
		return FileSystem.exists(htaccess);
	}
}