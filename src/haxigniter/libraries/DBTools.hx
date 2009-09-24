package haxigniter.libraries;

import haxigniter.libraries.Database;

#if php
import php.db.ResultSet;
#elseif neko
import neko.db.ResultSet;
#end

class DbTools
{
	public static function paginate(query : String, offset : Int, limit : Int, ?meta : { total: Int }, ?params : Iterable<Dynamic>, ?noCalcRows = false) : ResultSet
	{
		var db : DatabaseConnection = haxigniter.Application.instance().db;
		var result : ResultSet;
		
		if(db.driver == DatabaseDriver.mysql && !noCalcRows && meta != null)
		{
			// Replace select with special mysql command for calculating total rows.
			var calc : EReg = ~/^[\s\r\n]*SELECT[\s\r\n]+(?!SQL_CALC_FOUND_ROWS)/i;
			query = calc.replace(query, 'SELECT SQL_CALC_FOUND_ROWS ') + sqlLimit(offset, limit);
			
			result = db.query(query, params);
			
			meta.total = db.queryInt('SELECT FOUND_ROWS()');
		}
		else
		{
			// Use a simpler approach for sqlite: Select without limit, get length and select again.
			// TODO: Find better and faster solution. Rewrite query with COUNT(*)? Reflect on the sqlite object?
			if(meta != null)
			{
				result = db.query(query, params);
				meta.total = result.length;
			}

			result = db.query(query + sqlLimit(offset, limit), params);
		}
		
		return result;
	}
	
	private static function sqlLimit(offset : Int, limit : Int)
	{
		return ' LIMIT ' + offset + ',' + limit;
	}
}