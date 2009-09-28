package haxigniter.application.tests;

class TestRunner extends haxigniter.tests.TestRunner
{
	/**
	 * Add test classes here to auto-execute them, for example:
	 * this.add(new haxigniter.application.tests.unit.MyTestCase());
	 */
	private override function addTestClasses()
	{
		this.add(new haxigniter.application.tests.unit.When_doing_math());
	}

	/////////////////////////////////////////////////////////////////
	
	/**
	 * @param	runHaxigniterTests If false, haXigniter test suite is not run automatically.
	 */
	public function new(runHaxigniterTests = false)
	{
		super(runHaxigniterTests);
	}
}
