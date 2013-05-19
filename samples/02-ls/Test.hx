/**
 * ...
 * @author waneck
 */
class Test
{

	public static function main()
	{

		trace(new Ls());
	}

}

//after example at http://commons.apache.org/proper/commons-cli/usage.html
class Ls extends mcli.CommandLine
{
	/**
		do not hide entries starting with .
		@alias a
	**/
	public var all:Bool;

	/**
		do not list implied . and ..
		@alias A
	**/
	public var almostAll:Bool; //conversion to almost-all is implied

	/**
		print octal escapes for nongraphic characters
		@alias b
	**/
	public var escape:Bool;

	/**
		use SIZE-byte blocks
	**/
	public var blockSize:Int;

	/**
		do not list implied entries ending with -
		@alias B
	**/
	public var ignoreBackups:Bool;

	/**
		with -lt:
			sort by, and show, ctime (time of last modification of file status information)
		with -l:
			show ctime and sort by name
		otherwise:
			sort by ctime

		@command
		@alias c
	**/
	public var ctime:Bool;

	/**
		list entries by columns
		@command
		@alias C
	**/
	public var columns:Bool;
}
