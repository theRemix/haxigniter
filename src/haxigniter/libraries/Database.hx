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
	public var Connection : DatabaseConnection;
	
	public function new(message : String, connection : DatabaseConnection)
	{
		this.Connection = connection;
		super(message);
	}
}

// TODO: Debug query on error
// TODO: Operators in where queries
// TODO: Unquoted fields in where/data queries
class DatabaseConnection
{	
	public var Host : String;
	public var Port : Int;
	public var User : String;
	public var Pass : String;
	public var Database : String;
	public var Socket : String;
	public var Driver : DatabaseDriver;
	public var Debug : Bool;
	
	public var Connection : Connection;
	
	/**
	 * Set this value to change the string which is replaced by a parameter when executing a query.
	 * Default is '?'
	 */
	public var ParameterString : String;

	public var LastQuery(getLastQuery, null) : String;
	private var lastQuery : String;
	private function getLastQuery() : String { return this.lastQuery; }

	private static var alphaRegexp : EReg = ~/^\w+$/;

	public function Open() : Void
	{
		if(this.Connection != null)
			throw new DatabaseException('Connection is already open.', this);
		
		if(this.Driver == DatabaseDriver.Mysql)
			this.Connection = php.db.Mysql.connect({ 
				user: this.User, 
				socket: this.Socket, 
				port: this.Port, 
				pass: this.Pass, 
				host: this.Host, 
				database: this.Database
			});
		else // if(this.Driver == DatabaseDriver.Sqlite)
			this.Connection = php.db.Sqlite.open(this.Database);
	}
	
	public function Close() : Void
	{
		if(this.Connection != null)
		{
			this.Connection.close();
			this.Connection = null;
		}
	}

	///// Query methods /////////////////////////////////////////////
	
	public function Query(query : String, ?params : Iterable<Dynamic>) : ResultSet
	{
		if(params != null)
			query = this.queryParams(query, params);
		
		this.lastQuery = query;
		return this.Connection.request(query);
	}

	public function QueryRow(query : String, ?params : Iterable<Dynamic>) : Dynamic
	{
		var result = this.Query(query, params);
		return result.hasNext() ? result.next() : {};
	}

	public function QueryInt(query : String, ?params : Iterable<Dynamic>) : Int
	{
		var result = this.Query(query, params);
		return result.hasNext() ? result.getIntResult(0) : null;
	}

	public function QueryFloat(query : String, ?params : Iterable<Dynamic>) : Float
	{
		var result = this.Query(query, params);
		return result.hasNext() ? result.getFloatResult(0) : null;
	}

	public function QueryString(query : String, ?params : Iterable<Dynamic>) : String
	{
		var result = this.Query(query, params);
		return result.hasNext() ? result.getResult(0) : null;
	}

	///// C(R)UD methods ////////////////////////////////////////////
	
	public function Insert(table : String, data : Hash<Dynamic>, ?replace = false) : Int
	{
		this.testAlphaNumeric(table);
		
		var keys = '';
		var values = '';
		
		for(key in data.keys())
		{
			this.testAlphaNumeric(key);
			keys += ', ' + key;
			values += ', ' + this.Connection.quote(Std.string(data.get(key)));
		}
		
		var query = (replace ? 'REPLACE' : 'INSERT') + ' INTO ' + table + ' (' + keys.substr(2) + ') VALUES (' + values.substr(2) + ')';
		var result : ResultSet = this.Connection.request(query);
		
		this.lastQuery = query;		
		return result.length;
	}

	public function Replace(table : String, data : Hash<Dynamic>) : Int
	{
		return this.Insert(table, data, true);
	}
	
	public function Update(table : String, data : Hash<Dynamic>, ?where : Hash<Dynamic>, ?limit : Int) : Int
	{
		this.testAlphaNumeric(table);
		
		var set = '';
		var whereStr = '';
		
		for(key in data.keys())
		{
			this.testAlphaNumeric(key);
			set += ', ' + key + '=' + this.Connection.quote(Std.string(data.get(key)));
		}

		if(where != null)
		{
			for(key in where.keys())
			{
				this.testAlphaNumeric(key);
				whereStr += ' AND ' + key + '=' + this.Connection.quote(Std.string(where.get(key)));
			}
		}

		var query = 'UPDATE ' + table + ' SET ' + set.substr(2);
		
		if(where != null)
			query += ' WHERE ' + whereStr.substr(5);
		
		if(limit != null)
			query += ' LIMIT ' + limit;

		var result : ResultSet = this.Connection.request(query);
		
		this.lastQuery = query;
		return result.length;
	}
	
	public function Delete(table : String, ?where : Hash<Dynamic>, ?limit : Int) : Int
	{
		this.testAlphaNumeric(table);
		
		var whereStr = '';
		
		if(where != null)
		{
			for(key in where.keys())
			{
				this.testAlphaNumeric(key);
				whereStr += ' AND ' + key + '=' + this.Connection.quote(Std.string(where.get(key)));
			}
		}

		var query = 'DELETE FROM ' + table;
		
		if(where != null)
			query += ' WHERE ' + whereStr.substr(5);
		
		if(limit != null)
			query += ' LIMIT ' + limit;

		var result : ResultSet = this.Connection.request(query);
		
		this.lastQuery = query;
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
			var pos = query.indexOf(this.ParameterString == null ? '?' : this.ParameterString);
			if(pos == -1)
				throw new DatabaseException('Not enough parameters in query.', this);
			
			query = query.substr(0, pos) + this.Connection.quote(param) + query.substr(pos+1);
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
