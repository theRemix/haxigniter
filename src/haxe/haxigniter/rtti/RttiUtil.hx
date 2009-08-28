package haxigniter.rtti;

import haxe.rtti.CType;

typedef CArgument = {
	var type : String;
	var opt : Bool;
	var name : String;
}

class RttiUtil
{
	public static function getMethods(classType : Class<Dynamic>) : Hash<List<CArgument>>
	{
		var output = new Hash<List<CArgument>>();
		
		var root : Xml = Xml.parse(RttiUtil.getRtti(classType)).firstElement();
		var infos = new haxe.rtti.XmlParser().processElement(root);

		// Find class declaration and all functions in it.
		switch(infos)
		{
			case TClassdecl(cl):
				for(f in cl.fields)
				{
					switch(f.type)
					{
						// Test if field is a function
						case CFunction(args, ret):
							var argList = new List<CArgument>();
							
							for(arg in args)
							{
								switch(arg.t)
								{
									// Finally, create the CArgument type.
									case CClass(name, params):
										argList.add({type: name, opt: arg.opt, name: arg.name});
									
									default:
										// Do nothing if not an argument.
								}
							}
							
							output.set(f.name, argList);
	
						default:
							// Do nothing if not a method.
					}					
				}
			
			default:
				throw 'No RTTI class information found in ' + classType;
		}

		return output;
	}	
	
	public static function getRtti(classType : Class<Dynamic>) : String
	{
		var rtti : String = untyped classType.__rtti;
		if(rtti == null)
		{
			throw 'No RTTI information found in ' + classType + ' (class must implement haxe.rtti.Infos)';
		}
		
		return rtti;
	}
}