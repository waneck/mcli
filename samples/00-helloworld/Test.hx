package ;
import mcli.Dispatch;

/**
	Say hello.
	Example inspired by ruby's `executable` lib example
**/
class Test extends mcli.CommandLine
{
	/**
		Say it in uppercase?
	**/
	public var loud:Bool;

	/**
		Show this message.
	**/
	public function help()
	{
		Sys.println(this.showUsage());
	}

	public function runDefault(?name:String)
	{
		if(name == null)
			name = "World";
		var msg = 'Hello, $name!';
		if (loud)
			msg = msg.toUpperCase();
		Sys.println(msg);
	}

	public static function main()
	{
		new Dispatch(Sys.args()).dispatch(new Test());
	}

}
