package ;
import mcli.Dispatch;

/**
 * ...
 * @author waneck
 */
class Test
{

	public function new() 
	{
		
	}
	
	public static function main()
	{
		
	}
	
}

//replicating http://commons.apache.org/proper/commons-cli/usage.html
class Ant extends Dispatch
{
	@:arg('be extra quiet')
	public var quiet:Bool = false;
	@:arg('be extra verbose')
	public var verbose:Bool = false;
	@:arg('print debugging information')
	public var debug:Bool = false;
	@:arg('produce logging information without adornments')
	public var emacs:Bool = false;
	@:arg('use value for given property')
	public var D:Map<String,String> = new Map();
	
	@:arg('print this message')
	public function doHelp()
	{
		printHelp();
	}
	
	@:arg('print project help information')
	public function doProjectHelp()
	{
		
	}
	
	@:arg('print the version information and exit')
	public function doVersion()
	{
		
	}
	
	@:arg('use given file for log')
	public function doLogfile(file:String)
	{
		
	}
	
	@:arg('the class which is to perform logging')
	public function doLogger(clsname:String)
	{
		
	}
	
	@:arg('add an instance of class as a project listener')
	public function doListener(clsname:String)
	{
		
	}
	
	@:arg('use given buildfile')
	public function doBuildFile(file:String)
	{
		
	}
	
	@:arg('search for buildfile towards the root of the filesystem and use it')
	public function doFind(file:String)
	{
		
	}
}