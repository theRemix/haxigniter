package haxigniter.tests;

import haxigniter.libraries.Debug;
import haxigniter.tests.unit.When_UnitTesting_With_TestCase;
import haxigniter.tests.unit.When_using_a_TypeFactory;

class TestRunner extends haxe.unit.TestRunner
{
	/**
	 * Override this class and add your own test classes.
	 */
	private function addTestClasses() {}
	
	public function new(runHaxigniterTests : Bool = true)
	{
		super();

		if(runHaxigniterTests)
		{
			this.add(new When_UnitTesting_With_TestCase());
			this.add(new When_using_a_TypeFactory());
		}
		
		this.addTestClasses();		
	}
	
	public function runTests() : String
	{
		Debug.startBuffer();
		this.run();

		return Debug.endBuffer();
	}

	public function runAndDisplay() : Void
	{
		var output : String = this.runTests();
		php.Lib.print('<pre style="border:1px dashed blue; padding:5px; background-color:#F2F0EE;">' + output + '</pre>');
	}
	
	public function runAndDisplayOnError() : Void
	{
		var output : String = this.runTests();
		var errorTest : EReg = ~/\b[1-9]\d* failed\b/;
		
		if(errorTest.match(output))
			php.Lib.print('<pre style="border:1px dashed red; padding:5px; background-color:#F2F0EE;">' + output + '</pre>');
	}
}
