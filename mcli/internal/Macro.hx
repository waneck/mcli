package mcli.internal;
import haxe.macro.*;
import mcli.internal.Data;

class Macro
{
	public static function convertType(t:haxe.macro.Type):mcli.internal.Type
	{
		switch(t)
		{
			case TInst(c,p): switch c.toString() {
				case "String": TString;
				case "Map", "haxe.ds.StringMap":
			}
		}
	}
}
