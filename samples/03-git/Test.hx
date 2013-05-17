import mcli.CommandLine;
import mcli.Dispatch;

class Test {

	static function main()
	{
		Dispatch.addDecoder(new TestingDecoder());
		new Dispatch(Sys.args()).dispatch(new Git());
		trace(new Git());
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
	@:msg('The most commonly used git commands are:')

	@:arg('Add file contents to the index')
	public function add(d:Dispatch)
	{
		//re-dispatch here
	}

	@:arg('Find by binary search the change that introduced the bug')
	public function bisect(d:Dispatch)
	{

	}

	@:arg('List, create, or delete branches')
	public function branch(d:Dispatch)
	{

	}

	@:arg('Checkout a branch or paths to the working tree')
	public function checkout(d:Dispatch)
	{

	}

	@:arg('Testing argument')
	public function testingArgument(arg:Testing)
	{
		trace("called testing " + arg.str);

	}
}

class GitCommand extends CommandLine
{
	@:arg('be verbose', ['v'])
	public var verbose:Bool;

	@:arg('print this message', ['h'], '')
	public function help()
	{
		Sys.println(this.toString());
	}
}

class GitAdd extends GitCommand
{
	@:arg('dry run', ['n'])
	public var dryRun:Bool;

	@:arg('interactive picking', ['i'])
	public var interactive:Bool;

	@:arg('select hunks interactively', ['p'])
	public var patch:Bool;

	@:arg('edit current diff and apply', ['e'])
	public var edit:Bool;

	@:arg('allow adding otherwise ignored files', ['f'])
	public var force:Bool;

	@:arg('update tracked files', ['u'])
	public var update:Bool;

	@:arg("don't add, only refresh the index")
	public var refresh:Bool;

	@:arg("just skip files which cannot be added because of errors")
	public var ignoreErrors:Bool;

	@:arg("check if - even missing - files are ignored in dry run")
	public var ignoreMissing:Bool;

	public function runDefault(varArgs:Array<String>)
	{
	}
}

