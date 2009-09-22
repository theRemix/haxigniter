#if php
package haxigniter.views;

import php.Lib;
import php.NativeArray;
import Type;

/**
 * IMPORTANT NOTE: For smarty to work in haXe, you need to make a small adjustment to the file "internals/core.write_file.php".
 * You need to change this line:
 * 
 *      @unlink($params['filename']);
 * 
 * Into the following:
 * 
 *      if(file_exists($params['filename'])) 
 *            @unlink($params['filename']);
 * 
 * For more information: http://tylermac.wordpress.com/2009/09/06/haxe-php-smarty-flashdevelop/
 * 
 */
class Smarty extends haxigniter.views.ViewEngine
{
	private var smartyEngine : haxigniter.application.external.Smarty;
	
	private var cacheId : String;
	private var cachePath : String;
	
	public function new(?cachePath : String, ?cacheId : String, smartyClassFile : String = null, templatePath : String = null, compiledPath : String = null)
	{
		if(smartyClassFile == null)
			haxigniter.libraries.Server.requireExternal('smarty/libs/Smarty.class.php');
		else
			untyped __call__('require_once', smartyClassFile);
		
		this.smartyEngine = new haxigniter.application.external.Smarty();

		// super() will set correct variables for templatePath and compiledPath
		super(templatePath, compiledPath);

		this.smartyEngine.template_dir = this.templatePath;
		this.smartyEngine.compile_dir = this.compiledPath;
		
		this.cachePath = cachePath;
		this.cacheId = cacheId;
	}

	private function toPhpValue(value : Dynamic) : Dynamic
	{
		if(Std.is(value, Hash))
			return Lib.associativeArrayOfHash(value);
		else if(Std.is(value, Array))
			return Lib.toPhpArray(value);
		else if(Std.is(value, List))
			return Lib.toPhpArray(Lambda.array(value));
		else
			return value;
	}

	public override function assign(name : String, value : Dynamic) : Void
	{
		// TODO: This is >2.05 compatible only.
		this.smartyEngine.assign(name, this.toPhpValue(value));
	}
	
	public override function clearAssign(name : String) : Bool
	{
		var exists = this.smartyEngine.get_template_vars(name) != null;
		this.smartyEngine.clear_assign(name);
		
		return exists;
	}

	public override function render(fileName : String) : String
	{
		return this.smartyEngine.fetch(fileName, this.cacheId);
	}
}
#end
