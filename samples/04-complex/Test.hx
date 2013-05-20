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

	/**
		an enum
		@alias e
	**/
	public var anEnum:SimpleEnum;

	/**
		run quietly
		@alias q
	**/
	public var quiet:Bool = false;

	@:skip public var arg:SimpleEnum;
	@:skip public var hasRun:Bool = false;

	/**
		a function with no args
		@alias n
	**/
	public function noArgs()
	{
		if (!quiet)
			trace('no args called');
	}

	/**
		a function with an argument
		@alias a
	**/
	public function args(arg:SimpleEnum)
	{
		if (!quiet)
			trace(arg);
		this.arg = arg;
	}

	/**
		runs a mcli test
	**/
	public function test()
	{
		var c = new Complex();
		new Dispatch(["-qftDena","type","x=y","two","three"]).dispatch(c);
		if (c.arg != Three)
			trace("error");
		if (!c.hasRun)
			trace("error");
		if (c.defines.get("x") != "y")
			trace("error");
		if (c.anEnum != Two)
			trace("error");
		trace("tests finished");
	}

	public function runDefault()
	{
		if (!quiet)
			trace([simpleFlag, typeVar, defines.toString(), anEnum]);
		hasRun = true;
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

enum SimpleEnum
{
	ValueOne;
	Two;
	Three;
}
