package haxigniter.libraries;

import haxigniter.libraries.Database;

#if php
import php.db.ResultSet;
import php.db.Mysql;
import php.db.Sqlite;
#elseif neko
import neko.db.ResultSet;
import neko.db.Mysql;
import neko.db.Sqlite;
#end

class DBTools
{
	/*
	public static function Paginate(query : String, offset : Int, limit : Int, ?meta : { total: Int }, ?params : Iterable<Dynamic>, ?noCalcRows = false)
	{
		var db : DatabaseConnection = haxigniter.Application.instance.DB;
		var result : ResultSet;
		
		if(db.driver == DatabaseDriver.mysql && !noCalcRows)
		{
			// Replace select with special mysql command for calculating total rows.
			var calc : EReg = ~/^[\s\r\n]*SELECT[\s\r\n]+(?!SQL_CALC_FOUND_ROWS)/i;
			query = calc.replace(query, 'SELECT SQL_CALC_FOUND_ROWS ') + sqlLimit(offset, limit);
			
			result = db.query(query, params);
			
			if(meta != null)
				meta.total = db.queryInt('SELECT FOUND_ROWS()');
		}
		else
		{
			result = db.query(query, params);
		}
	}
	
	private static function sqlLimit(offset : Int, limit : Int)
	{
		return ' LIMIT ' + offset + ',' + limit;
	}
	*/
}