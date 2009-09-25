package haxigniter.application.tests;

/**
 * This is a template for your own integrity tests.
 * For the default application, browse to dev/integrity/password to run the tests.
 */
class Integrity extends haxigniter.tests.Integrity
{
	// Integrity test template method
	public function testLogic(title : { value : String }) : Bool
	{
		printHeader('Logic tests - Template class (application/tests/Integrity.hx)');
		title.value = 'true != false';
		
		return true != false;
	}

	public function new() {	super(); }
}
