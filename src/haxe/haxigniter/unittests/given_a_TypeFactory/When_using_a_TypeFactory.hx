package haxigniter.unittests.given_a_TypeFactory;

import Type;
import haxigniter.types.TypeFactory;
import haxigniter.unit.TestCase2;

/**
* This is fun, unit testing a unit test class.
*/
class When_using_a_TypeFactory extends TestCase2
{
	public function test_Then_CreateType_should_return_valid_types_based_on_string_value()
	{
		var a = TypeFactory.CreateType('Int', '123');
		
		this.assertEqual(123, cast(a, Int));
		this.assertIsA(a, ValueType.TInt);

		var b = TypeFactory.CreateType('Float', '123.456');
		
		this.assertEqual(123.456, cast(b, Float));
		this.assertIsA(b, ValueType.TFloat);

		var c = TypeFactory.CreateType('String', 'Nice');
		
		this.assertEqual('Nice', cast(c, String));
	}
}