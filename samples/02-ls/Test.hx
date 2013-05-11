/**
 * ...
 * @author waneck
 */
class Test
{

	public function new() 
	{
		
	}
	
}

//after example at http://commons.apache.org/proper/commons-cli/usage.html
class Ls
{
	@:arg('do not hide entries starting with .', ['a'])
	public var all:Bool;
	
	@:arg('do not list implied . and ..', ['A'])
	public var almostAll:Bool; //conversion to almost-all is implied
	
	@:arg(
}