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
			throw new haxigniter.exceptions.Exception('[DatabaseConnection] Connection is already open.');
		
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
	
	public function Query(query : String, ?params : List<Dynamic> = null) : ResultSet
	{
		return this.connection.request(query);
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
