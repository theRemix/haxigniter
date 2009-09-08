package haxigniter.unittests;

import haxigniter.libraries.Debug;
import haxigniter.unittests.given_a_TestCase2.When_UnitTesting_With_TestCase2;
import haxigniter.unittests.given_a_TypeFactory.When_using_a_TypeFactory;

class TestRunner extends haxe.unit.TestRunner
{
	public function new()
	{
		super();
		this.add(new When_UnitTesting_With_TestCase2());
		this.add(new When_using_a_TypeFactory());
		
#if php
		Debug.StartPhpBuffer();
#end
		this.run();
#if php
		var output : String = Debug.EndPhpBuffer();
		var errorTest : EReg = ~/\b[1-9]\d* failed\b/;
		
		if(errorTest.match(output))
			php.Lib.print('<pre style="border:1px dashed green; padding:5px; background-color:#F2F0EE;">' + output + '</pre>');
#end
	}
}