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

	@:arg('print octal escapes for nongraphic ' +
		'characters', ['b'])
	public var escape:Bool;

	@:arg('use SIZE-byte blocks')
	public var blockSize:Int;

	@:arg('do not list implied entries ending with -', ['B'])
	public var ignoreBackups:Bool;

	@:arg("with -lt: sort by, and show, ctime (time of last "
			+ "modification of file status information) with "
			+ "-l:show ctime and sort by name otherwise: sort "
			+ "by ctime", ['c'], '' )
	public var ctime:Bool;

	@:arg('list entries by columns', ['C'], '')
	public var columns:Bool;
}
