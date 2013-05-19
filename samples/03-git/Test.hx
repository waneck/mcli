import mcli.CommandLine;
import mcli.Dispatch;

class Test {

	static function main()
	{
		Dispatch.addDecoder(new TestingDecoder());
		new Dispatch(Sys.args()).dispatch(new Git());
	}

}

class Testing
{
	public var str:String;

	public function new(str)
	{
		this.str = str;
	}
}

class TestingDecoder
{
	public function new()
	{

	}

	public function fromString(s:String):Testing
	{
		return new Testing(s + ".");
	}
}

class Git extends CommandLine
{
	/**
		[region] The most commonly used git commands are:
		Add file contents to the index
	**/
	public function add(d:Dispatch)
	{
		//re-dispatch here
		trace("git add called");
		d.dispatch(new GitAdd());
	}

	/**
		Find by binary search the change that introduced the bug
	**/
	public function bisect(d:Dispatch)
	{

	}

	/**
		List, create, or delete branches
	**/
	public function branch(d:Dispatch)
	{

	}

	/**
		Checkout a branch or paths to the working tree
	**/
	public function checkout(d:Dispatch)
	{

	}

	/**
		Testing argument
	**/
	public function testingArgument(arg:Testing)
	{
		trace("called testing " + arg.str);

	}
}

class GitCommand extends CommandLine
{
	/**
		be verbose
		@alias v
	**/
	public var verbose:Bool;

	/**
		print this message
		@command
		@alias h
	**/
	public function help()
	{
		Sys.println(this.toString());
	}
}

class GitAdd extends GitCommand
{
	/**
		dry run
		@alias n
	**/
	public var dryRun:Bool;

	/**
		interactive picking
		@alias i
	**/
	public var interactive:Bool;

	/**
		select hunks interactively
		@alias p
	**/
	public var patch:Bool;

	/**
		edit current diff and apply
		@alias e
	**/
	public var edit:Bool;

	/**
		allow adding otherwise ignored files
		@alias f
	**/
	public var force:Bool;

	/**
		update tracked files
		@alias u
	**/
	public var update:Bool;

	/**
		don't add, only refresh the index
	**/
	public var refresh:Bool;

	/**
		just skip files which cannot be added because of errors
	**/
	public var ignoreErrors:Bool;

	/**
		check if - even missing - files are ignored in dry run
	**/
	public var ignoreMissing:Bool;

	public function runDefault(varArgs:Array<String>)
	{
		trace("running default with " + varArgs);
	}
}

