package haxigniter.unittests;

import haxigniter.libraries.Debug;
import haxigniter.unittests.given_a_TestCase2.When_UnitTesting_With_TestCase2;

class TestRunner extends haxe.unit.TestRunner
{
	public function new()
	{
		super();
		this.add(new When_Asserting_With_TestCase2());
		
#if php
		Debug.StartPhpBuffer();
#end
		this.run();
#if php
		var output : String = Debug.EndPhpBuffer();
		var errorTest : EReg = ~/\b[1-9]\d* failed\b/;
		
		if(errorTest.match(output))
			php.Lib.print(output);
#end
	}
}