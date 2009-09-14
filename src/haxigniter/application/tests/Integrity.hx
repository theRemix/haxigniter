package haxigniter.application.tests;

import php.FileSystem;
import php.Lib;
import php.Web;

/**
 * This is a template for your own integrity tests.
 * Browse to /start/integrity to run the tests.
 */
class Integrity extends haxigniter.tests.Integrity
{
	// Integrity test template method
	public function testLogic(title : { value : String }) : Bool
	{
		printHeader('Logic tests');
		
		title.value = 'Test if not false is true';
		return !false == true;
	}

	public function new() {	super(); }
}
