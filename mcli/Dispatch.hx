package mcli;
import mcli.internal.Data;
#if macro
import haxe.macro.*;
#end

class Dispatch
{

	public static function showUsageOf(args:Array<Argument>):String
	{
		return args.toString(); //TODO do it right
	}

	// macro public function dispatch(e:Expr)
	// {
	// 	//get type of expr
	// 	//traverse through type adding definitions
	// 	return e;
	// }
}
