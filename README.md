[![Build Status](https://travis-ci.org/waneck/mcli.svg?branch=master)](https://travis-ci.org/waneck/mcli)

#mcli

## Description
mcli is a simple, opinionated and type-safe way to create command line interfaces.
It will map a class definition into expected command-line arguments in an intuitive and straight-forward way.

## Features
* Easy to use
* Public variables and functions become options
* Can work with any type, not just basic types
* Support for Haxe's Map<> for key=value definitions
* Extensible
* Public domain license

## Example

```
/**
	Say hello.
	Example inspired by ruby's "executable" lib example
**/
class HelloWorld extends mcli.CommandLine
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
		Sys.exit(0);
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
		new mcli.Dispatch(Sys.args()).dispatch(new HelloWorld());
	}

}
```

Compiling this with
```
-neko hello.n
-main HelloWorld
-lib mcli
```

Will render the following program:
```
$ neko hello
Hello, World!
$ neko hello Caue
Hello, Caue!
$ neko hello --loud Caue
HELLO, CAUE!
$ neko hello Caue --loud
HELLO, CAUE!
```

You can also generate help for commands:
```
$ neko hello --help
Say hello. 
Example inspired by ruby's `executable` lib example

  --loud     Say it in uppercase?
  --help     Show this message.
```

You can see more complex examples looking at the samples provided

## License
As stated above, the mcli library is in public domain

## Status
Everything should be working, but it's currently in beta status.
After some tests it will get a major release. You may use github's issues list to add feature requests and bug reports.
Pull requests for new features are welcome, provided it won't hurt backwards compatibility and existing features and follow mcli's minimalist approach
