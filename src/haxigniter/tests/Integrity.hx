package haxigniter.tests;

#if php
import php.FileSystem;
import php.io.File;
import php.Lib;
import php.Web;
#elseif neko
import neko.FileSystem;
import neko.io.File;
import neko.Lib;
import neko.Web;
#end

class Integrity
{
	public var testMethodPrefix : String;
	private var config : haxigniter.libraries.Config;
	
	public function new()
	{
		this.config = haxigniter.Application.instance().config;
		this.testMethodPrefix = 'test';
	}
	
	public function run()
	{
		for(field in Type.getInstanceFields(Type.getClass(this)))
		{
			if(StringTools.startsWith(field, this.testMethodPrefix) && Reflect.isFunction(Reflect.field(this, field)))
				runTest(field);
		}
	}
	
	private function runTest(methodName : String)
	{
		var title = {value: methodName};
		var result : Bool = Reflect.callMethod(this, Reflect.field(this, methodName), [title]);
		
		if(result != null)
		{
			Lib.print('<div style="font-family: Verdana; font-size:12px; float:left; display:inline; padding:4px; margin:1px; border:1px solid gray; width:99%;">');
			Lib.print('<div style="float:left; padding:0 3px 0 3px;">' + title.value + '</div>');

			if(result == true)
				Lib.print('<div style="width:70px; float:right; background-color:#2D1; padding:1px 3px 1px 3px; text-align:center;">OK</div>');
			else
				Lib.print('<div style="width:70px; float:right; background-color:#C12; padding:1px 3px 1px 3px; text-align:center;">FAILED</div>');

			//else if(result == null)
				//Lib.print('<div style="width:70px; float:right; padding:1px 3px 1px 3px; text-align:center;"><strong>?</strong></div>');
		
			Lib.print('</div>');
			Web.flush();
		}
	}
	
	private function printHeader(text : String)
    {
        Lib.print('<div style="font-family: Verdana; font-size:13px; font-weight:bold; float:left; display:inline; padding:8px 4px 0 4px; margin:1px; border:0; width:99%;">');
        Lib.print('<div style="float:left; padding:0;">' + text + '</div></div>');
		Web.flush();
    }

	private function isWritable(path : String) : Bool
	{
		#if php
		return untyped __call__('is_writable', path);
		#elseif neko
		// TODO: Implement neko version of is_writable()
		trace("isWritable() mock - do not trust this value<br>");
		return true;
		#end
	}
	
	/////////////////////////////////////////////////////////////////
	
	public function testCachePath(title : { value : String }) : Bool
	{
		printHeader('[haXigniter] Directory access');
		
		title.value = 'Cache path <b>"' + config.cachePath + '"</b> exists and is writable';
		return this.isWritable(config.cachePath);
	}

	public function testLogPath(title : { value : String }) : Bool
	{
		title.value = 'Log path <b>"' + config.logPath + '"</b> exists and is writable';
		return this.isWritable(config.logPath);
	}

	public function testSessionPath(title : { value : String }) : Bool
	{
		title.value = 'Session path <b>"' + config.sessionPath + '"</b> exists and is writable';
		return this.isWritable(config.sessionPath);
	}

	public function testHtaccess(title : { value : String }) : Bool
	{
		printHeader('[haXigniter] File integrity');

		var htaccess = FileSystem.fullPath(config.applicationPath + '../../.htaccess');

		title.value = '<b>"' + htaccess + '"</b> exists to prevent access to haXigniter files';
		
		return FileSystem.exists(htaccess);
	}

	#if php
	public function testSmartyPatch(title : { value : String }) : Bool
	{
		var smarty = FileSystem.fullPath(config.applicationPath + 'external/smarty/libs/internals/core.write_file.php');

		if(!FileSystem.exists(smarty))
			return null;

		title.value = 'Smarty file <b>"' + smarty + '"</b> is patched according to haxigniter/views/Smarty.hx';
		
		var patch : EReg = ~/file_exists\s*\([^\)]*\$params\[['"]filename['"]\]/;
		
		return patch.match(File.getContent(smarty));
	}
	#end
}
