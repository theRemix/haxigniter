package haxigniter.application.config; 
import haxigniter.libraries.Database;

/* =============================================================== */
/* ===== Database configuration file, edit only below here ======= */
/* =============================================================== */

/*
|--------------------------------------------------------------------------
| Development (local) connection
|--------------------------------------------------------------------------
|
| These database settings will be used when Config.Development is true.
| Set them as appropriate. Disable database completely by setting the
| static variable to false.
|
| NOTE: If no host is set, database will be disabled!
|
*/
class DevelopmentConnection extends DatabaseConnection
{
	public static var Enabled = true;
	
	public function new()
	{
		this.Host = 'localhost';
		this.User = 'root';
		this.Pass = '';
		this.Database = 'selfimprove';
		this.Driver = DatabaseDriver.Mysql; // Can also be Sqlite, then Database will be used as filename.
		this.Debug = true; // Displays debug information on database/query errors
		this.Port = 3306;
		this.Socket = null;
	}
}

/*
|--------------------------------------------------------------------------
| Online (live) connection
|--------------------------------------------------------------------------
|
| These database settings will be used when Config.Development is false.
| Disable database completely by setting the static variable to false.
|
*/
class OnlineConnection extends DatabaseConnection
{
	public static var Enabled = false;
	
	public function new()
	{
		this.Host = '';
		this.User = '';
		this.Pass = '';
		this.Database = '';
		this.Driver = DatabaseDriver.Mysql; // Can also be Sqlite, then Database will be used as filename.
		this.Debug = false; // Displays debug information on database/query errors
		this.Port = 3306;
		this.Socket = null;
	}
}

/* =============================================================== */
/* ===== Database configuration file end, edit only above here === */
/* =============================================================== */
