package haxigniter.libraries;

import haxigniter.exceptions.Exception;

import php.db.Mysql;
import php.db.Sqlite;
import php.db.Connection;
import php.db.ResultSet;

enum DatabaseDriver
{
	Mysql;
	Sqlite;
}

class DatabaseException extends Exception {}

// TODO: Debug query on error
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

	private var enabled : Bool;
	private var connection : Connection;
	
	public function Open() : Void
	{
		if(this.connection != null)
			throw new DatabaseException('Connection is already open.');
		
		if(this.Driver == DatabaseDriver.Mysql)
			this.connection = php.db.Mysql.connect({ 
				user: this.User, 
				socket: this.Socket, 
				port: this.Port, 
				pass: this.Pass, 
				host: this.Host, 
				database: this.Database
			});
		else // if(this.Driver == DatabaseDriver.Sqlite)
			this.connection = php.db.Sqlite.open(this.Database);
	}
	
	public function Close() : Void
	{
		if(this.connection != null)
		{
			this.connection.close();
			this.connection = null;
		}
	}
	
	public function Query(query : String, ?params : Iterable<Dynamic> = null) : ResultSet
	{
		if(params != null)
			query = this.queryParams(query, params);
		
		return this.connection.request(query);
	}
	
	private function queryParams(query : String, params : Iterable<Dynamic>)
	{
		for(param in params)
		{
			var pos = query.indexOf('?');
			if(pos == -1)
				throw new DatabaseException('Not enough parameters in query.');
			
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
