package haxigniter.application.models;

import haxigniter.types.TypeFactory;

class ItemsModel extends haxigniter.libraries.Model
{
	public static function item(id : DbID) : Dynamic
	{
		var sql = 'SELECT * FROM items WHERE id=?';
		
		return haxigniter.Application.instance().db.queryRow(sql, [id.toInt()]);
	}	
}