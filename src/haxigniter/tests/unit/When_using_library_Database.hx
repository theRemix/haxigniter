package haxigniter.tests.unit;

import haxigniter.libraries.Database;

#if php
import php.db.Connection;
import php.db.ResultSet;
#elseif neko
import neko.db.Connection;
import neko.db.ResultSet;
#end

class Mockconnection implements Connection
{
	public function new() {}
	
	public function close() : Void {}
	public function commit() : Void {}
	public function dbName() : String { return 'mockdb'; }
	public function escape( s : String ) : String { return 'E*' + s + '*E'; }
	public function lastInsertId() : Int { return 0; }
	public function quote( s : String ) : String { return 'Q*' + s + '*Q'; }
	public function request( sql : String ) : ResultSet { return new MockResultSet(); }
	public function rollback() : Void {}
	public function startTransaction() : Void {}
}

class Mockdatabase extends DatabaseConnection
{
	public function new() { }
	
	public override function open()
	{
		if(this.connection != null)
			throw new DatabaseException('Connection is already open.', this);

		this.connection = new Mockconnection();
	}
}

class MockResultSet implements ResultSet
{
	public function new() { }
	
	private function getLength() : Int { return 0; }
	private function getNFields() : Int { return 0; }
	
	public var length(getLength, null) : Int;
	public var nfields(getNFields, null) : Int;
	public function getFloatResult(n : Int) : Float { return 0; }
	public function getIntResult(n : Int) : Int { return 0; }
	public function getResult(n : Int) : String { return ''; }
	public function hasNext() : Bool { return false; }
	public function next() : Dynamic { return null; }
	public function results() : List<Dynamic> { return new List(); }
}

class When_using_library_Database extends haxigniter.tests.TestCase
{
	private var db : Mockdatabase;
	
	public override function setup()
	{
		db = new Mockdatabase();
	}
	
	public function test_Then_dynamic_objects_should_be_iterated()
	{
		var data1 = { me: 'who', data: 'you' };
		
		var data2 = new Hash<Dynamic>();
		data2.set('who', 'me');
		data2.set('you', 1337);

		db.insert('test', data1);
		this.assertEqual('INSERT INTO test (me, data) VALUES (Q*who*Q, Q*you*Q)', db.lastQuery);
		
		db.insert('test', data2);
		this.assertEqual('INSERT INTO test (who, you) VALUES (Q*me*Q, Q*1337*Q)', db.lastQuery);
		
		db.update('test', data1, data2, 5);
		this.assertEqual('UPDATE test SET me=Q*who*Q, data=Q*you*Q WHERE who=Q*me*Q AND you=Q*1337*Q LIMIT 5', db.lastQuery);

		db.delete('test', data1, 1);
		this.assertEqual('DELETE FROM test WHERE me=Q*who*Q AND data=Q*you*Q LIMIT 1', db.lastQuery);	
	}
}
