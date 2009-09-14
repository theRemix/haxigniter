package haxigniter.libraries;

import php.db.Mysql;
import php.db.Sqlite;
import php.db.Connection;
import php.db.ResultSet;

enum DatabaseDriver
{
	Mysql;
	Sqlite;
}

class DatabaseException extends haxigniter.exceptions.Exception
{
	public var connection : DatabaseConnection;
	
	public function new(message : String, connection : DatabaseConnection)
	{
		this.connection = connection;
		super(message);
	}
}

// TODO: Debug query on error
// TODO: Operators in where queries
// TODO: Unquoted fields in where/data queries
class DatabaseConnection
{	
	public var host : String;
	public var port : Int;
	public var user : String;
	public var pass : String;
	public var database : String;
	public var socket : String;
	public var driver : DatabaseDriver;
	public var debug : Bool;
	
	public var connection : Connection;
	
	/**
	 * Set this value to change the string which is replaced by a parameter when executing a query.
	 * Default is '?'
	 */
	public var parameterString : String;

	public var lastQuery(getLastQuery, null) : String;
	private var my_lastQuery : String;
	private function getLastQuery() : String { return this.my_lastQuery; }

	private static var alphaRegexp : EReg = ~/^\w+$/;

	public function open() : Void
	{
		if(this.connection != null)
			throw new DatabaseException('Connection is already open.', this);
		
		if(this.driver == DatabaseDriver.Mysql)
			this.connection = php.db.Mysql.connect(this);
		else // if(this.driver == DatabaseDriver.Sqlite)
			this.connection = php.db.Sqlite.open(this.database);
	}
	
	public function close() : Void
	{
		if(this.connection != null)
		{
			this.connection.close();
			this.connection = null;
		}
	}

	///// Query methods /////////////////////////////////////////////
	
	public function query(query : String, ?params : Iterable<Dynamic>) : ResultSet
	{
		if(params != null)
			query = this.queryParams(query, params);
		
		this.my_lastQuery = query;
		return this.connection.request(query);
	}

	public function queryRow(query : String, ?params : Iterable<Dynamic>) : Dynamic
	{
		var result = this.query(query, params);
		return result.hasNext() ? result.next() : {};
	}

	public function queryInt(query : String, ?params : Iterable<Dynamic>) : Int
	{
		var result = this.query(query, params);
		return result.hasNext() ? result.getIntResult(0) : null;
	}

	public function queryFloat(query : String, ?params : Iterable<Dynamic>) : Float
	{
		var result = this.query(query, params);
		return result.hasNext() ? result.getFloatResult(0) : null;
	}

	public function queryString(query : String, ?params : Iterable<Dynamic>) : String
	{
		var result = this.query(query, params);
		return result.hasNext() ? result.getResult(0) : null;
	}

	///// C(R)UD methods ////////////////////////////////////////////
	
	public function insert(table : String, data : Hash<Dynamic>, ?replace = false) : Int
	{
		this.testAlphaNumeric(table);
		
		var keys = '';
		var values = '';
		
		for(key in data.keys())
		{
			this.testAlphaNumeric(key);
			keys += ', ' + key;
			values += ', ' + this.connection.quote(Std.string(data.get(key)));
		}
		
		var query = (replace ? 'REPLACE' : 'INSERT') + ' INTO ' + table + ' (' + keys.substr(2) + ') VALUES (' + values.substr(2) + ')';
		var result : ResultSet = this.connection.request(query);
		
		this.my_lastQuery = query;		
		return result.length;
	}

	public function replace(table : String, data : Hash<Dynamic>) : Int
	{
		return this.insert(table, data, true);
	}
	
	public function update(table : String, data : Hash<Dynamic>, ?where : Hash<Dynamic>, ?limit : Int) : Int
	{
		this.testAlphaNumeric(table);
		
		var set = '';
		var whereStr = '';
		
		for(key in data.keys())
		{
			this.testAlphaNumeric(key);
			set += ', ' + key + '=' + this.connection.quote(Std.string(data.get(key)));
		}

		if(where != null)
		{
			for(key in where.keys())
			{
				this.testAlphaNumeric(key);
				whereStr += ' AND ' + key + '=' + this.connection.quote(Std.string(where.get(key)));
			}
		}

		var query = 'UPDATE ' + table + ' SET ' + set.substr(2);
		
		if(where != null)
			query += ' WHERE ' + whereStr.substr(5);
		
		if(limit != null)
			query += ' LIMIT ' + limit;

		var result : ResultSet = this.connection.request(query);
		
		this.my_lastQuery = query;
		return result.length;
	}
	
	public function delete(table : String, ?where : Hash<Dynamic>, ?limit : Int) : Int
	{
		this.testAlphaNumeric(table);
		
		var whereStr = '';
		
		if(where != null)
		{
			for(key in where.keys())
			{
				this.testAlphaNumeric(key);
				whereStr += ' AND ' + key + '=' + this.connection.quote(Std.string(where.get(key)));
			}
		}

		var query = 'DELETE FROM ' + table;
		
		if(where != null)
			query += ' WHERE ' + whereStr.substr(5);
		
		if(limit != null)
			query += ' LIMIT ' + limit;

		var result : ResultSet = this.connection.request(query);
		
		this.my_lastQuery = query;
		return result.length;
	}	

	/////////////////////////////////////////////////////////////////
	
	private inline function testAlphaNumeric(value : String) : Void
	{	
		if(value == null || !DatabaseConnection.alphaRegexp.match(value))
			throw new DatabaseException('Invalid parameter: ' + value, this);
	}
	
	private function queryParams(query : String, params : Iterable<Dynamic>)
	{
		for(param in params)
		{
			var pos = query.indexOf(this.parameterString == null ? '?' : this.parameterString);
			if(pos == -1)
				throw new DatabaseException('Not enough parameters in query.', this);
			
			query = query.substr(0, pos) + this.connection.quote(param) + query.substr(pos+1);
		}
		
		return query;
	}
}

/*
$db['local']['dbprefix'] = "";
$db['local']['pconnect'] = FALSE;
$db['local']['cache_on'] = FALSE;
$db['local']['cachedir'] = "";
$db['local']['char_set'] = "latin1";
$db['local']['dbcollat'] = "latin1_swedish_ci";	
*/
