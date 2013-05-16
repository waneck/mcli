package mcli;
import mcli.internal.Data;
#if macro
import haxe.macro.*;
#end

class Dispatch
{
	public static function argToString(arg:Argument, screenSize=80)
	{
		var prefix = switch(arg.kind)
		{
			case SubDispatch: "";
			default: "-";
		};

		var versions = arg.aliases != null ? arg.aliases.concat([arg.command]) : [arg.command];
		versions = versions.filter(function(s) return s != null && s != "");

		if (versions.length == 0) return "";
		versions.sort(function(s1,s2) return Reflect.compare(s1.length, s2.length));

		var desc = (arg.description != null ? arg.description : "");

		var ret = new StringBuf();
		ret.add("  ");
		ret.add(StringTools.rpad(versions.map(function(v) return (v.length == 1 || versions.length == 1) ? prefix + v : prefix + prefix + v).join(", "), " ", 30));
		ret.add("   ");
		if (arg.description != null)
			ret.add(arg.description);
		var consolidated = ret.toString();
		if (consolidated.length > screenSize)
		{
			ret = new StringBuf();
			var c = consolidated.split(" "), ccount = 0;
			for (word in c)
			{
				ccount += word.length + 1;
				if (ccount >= screenSize)
				{
					ret.addChar("\n".code);
					for (i in 0...7)
					ret.add("     ");
					ccount = 35;
				}
				ret.add(word);
				ret.add(" ");
			}
			return ret.toString();
		} else {
			return consolidated;
		}
	}

	public static function showUsageOf(args:Array<Argument>, screenSize=80):String
	{
		var buf = new StringBuf();
		for (arg in args)
		{
			var str = argToString(arg, screenSize);
			if (str.length > 0)
			{
				buf.add(str);
				buf.addChar('\n'.code);
			}
		}
		return buf.toString();
	}

	// macro public function dispatch(e:Expr)
	// {
	// 	//get type of expr
	// 	//traverse through type adding definitions
	// 	return e;
	// }
}
