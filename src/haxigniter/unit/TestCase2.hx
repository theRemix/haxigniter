package haxigniter.unit;

import haxe.PosInfos;
import haxe.unit.TestCase;
import Type;

/**
* Methods in this class are based on simpletest (http://www.simpletest.org/)
*/
class TestCase2 extends TestCase
{
	public function assertNull(input : Dynamic) : Void
	{
		this.assertTrue(input == null);
	}

	public function assertNotNull(input : Dynamic) : Void
	{
		this.assertFalse(input == null);
	}

	public function assertIsA(input : Dynamic, typeTest : Dynamic, isTrue = true) : Void
	{
		var assertFunction : Bool -> haxe.PosInfos -> Void;
		var inputClass : Class<Dynamic> = Type.getClass(input);
		
		// Could not assign this using the ternary operator!
		if(isTrue)
			assertFunction = this.assertTrue;
		else
			assertFunction = this.assertFalse;
		
		if(inputClass != null)
			assertFunction(inputClass == typeTest, null);
		else
			assertFunction(Type.typeof(input) == typeTest, null);
	}
	
	public function assertNotA(input : Dynamic, typeTest : Dynamic) : Void
	{
		this.assertIsA(input, typeTest, false);
	}
	
	public function assertEqual<T>(expected : T, actual : T) : Void
	{
		this.assertEquals(expected, actual);
	}

	public function assertNotEqual<T>( expected: T , actual: T,  ?c : PosInfos ) : Void 
	{
		currentTest.done = true;
		if (actual == expected)
		{
			currentTest.success = false;
			currentTest.error   = "expected '" + expected + "' not equal to '" + actual + "'";
			currentTest.posInfos = c;
			throw currentTest;
		}
	}
	
	public function assertPattern(pattern : EReg, input : Dynamic) : Void
	{
		this.assertTrue(pattern.match(Std.string(input)));
	}

	public function assertNotPattern(pattern : EReg, input : Dynamic) : Void
	{
		this.assertFalse(pattern.match(Std.string(input)));
	}
	
	public function expectException(expected : String, e : Dynamic) : Void
	{
		this.assertTrue(Std.string(e) == expected);
	}

	public function expectExceptionPattern(expected : EReg, e : Dynamic) : Void
	{
		this.assertTrue(expected.match(Std.string(e)));
	}
}