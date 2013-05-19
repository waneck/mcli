import mcli.Dispatch;

class Test
{
	static function main()
	{
		new Dispatch(Sys.args()).dispatch(new Complex());
	}
}

class Complex extends mcli.CommandLine
{
	//test stacked aliases
	/**
		a simple flag
		@alias f
	**/
	public var simpleFlag:Bool = false;

	/**
		a type var
		@alias t
	**/
	public var typeVar:String = "defaultVal";

	/**
		a map
		@alias D
	**/
	public var defines:Map<String,String> = new Map();

	public function runDefault()
	{
		trace([simpleFlag, typeVar, defines.toString()]);
		defines.set("a", "b");
		trace(defines.get('a'));
	}

	/**
		shows this message
		@alias h
	**/
	public function help()
	{
		Sys.println(this.showUsage());
	}
}
