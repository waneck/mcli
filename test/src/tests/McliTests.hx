package tests;
import utest.Assert.*;
import mcli.*;

class McliTests
{
	public function new()
	{
	}

	public function test_basictypes()
	{
		var bt = new BasicTypes();
		inline function dispatch(args:Array<String>)
			new Dispatch(args).dispatch(bt,false);

		equals(bt.bool,false);
		equals(bt.string,'hello');
		equals(bt.ivar,0);
		equals(bt.fvar,0);

		dispatch(['--bool']);
		isTrue(bt.didRunDefault);
		equals(bt.bool,true);
		bt.bool = false;
		dispatch(['-b']);
		equals(bt.bool,true);
		bt.bool = false;

		dispatch(['--string','hi']);
		equals(bt.string,'hi');
		bt.string = null;
		dispatch(['-s','hi!']);
		equals(bt.string,'hi!');
		bt.string = null;

		dispatch(['--ivar','42']);
		equals(bt.ivar,42);
		bt.ivar = 0;
		dispatch(['-i','44']);
		equals(bt.ivar,44);
		bt.ivar = 0;

		// negative
		dispatch(['--ivar','-42']);
		equals(bt.ivar,-42);
		bt.ivar = 0;
		dispatch(['-i','-1']);
		equals(bt.ivar,-1);
		bt.ivar = 0;

		dispatch(['--fvar','4.2']);
		equals(bt.fvar,4.2);
		bt.fvar = 0;
		dispatch(['-f','.44']);
		equals(bt.fvar,.44);
		bt.fvar = 0;

		// negative
		dispatch(['--fvar','-.42']);
		equals(bt.fvar,-.42);
		bt.fvar = 0;
		dispatch(['-f','-1.2']);
		equals(bt.fvar,-1.2);
		bt.fvar = 0;

		dispatch(['--map','v1','--map','v2=test']);
		equals(bt.map['v1'],null);
		isTrue(bt.map.exists('v1'));
		equals(bt.map['v2'],'test');

		bt.map = new Map();
		dispatch(['-m','v1=','-m','v2=test2']);
		equals(bt.map['v1'],'');
		equals(bt.map['v2'],'test2');

		// many
		bt = new BasicTypes();
		dispatch(['-sbfim','thestring','42.2','29','key=value']);
		equals(bt.string,'thestring');
		equals(bt.fvar,42.2);
		equals(bt.bool,true);
		equals(bt.ivar,29);
		equals(bt.map['key'],'value');
	}

	public function test_funcs()
	{
		var d = new WithSubDispatch();
		inline function dispatch(args:Array<String>)
			new Dispatch(args).dispatch(d,false);

		dispatch(['--one-arg','12']);
		equals(d.i,12);
		dispatch(['--two-args','15','10.2']);
		equals(d.i,15);
		equals(d.f,10.2);

		// order of function calls
		dispatch(['-OT','11','14','10.1']);
		equals(d.i,14);
		equals(d.f,10.1);
		dispatch(['-TO','1','2.2','3']);
		equals(d.i,3);
		equals(d.f,2.2);

		// error when cannot run
		raises(function() dispatch(['something']));
		raises(function() dispatch(['something','else']));
		raises(function() dispatch(['sub','something']));
		raises(function() dispatch(['sub','something','else']));

		d = new WithSubDispatchAndDefault();
		dispatch(['something']);
		same(d.varArgs,['something']);
		dispatch(['something','else']);
		same(d.varArgs,['something','else']);
		dispatch(['sub','something']);
		same(d.varArgs,['something']);
		dispatch(['sub','something','else']);
		same(d.varArgs,['something','else']);

		// sub dispatch
		for (disp in [new WithSubDispatch(), new WithSubDispatchAndDefault()])
		{
			d = disp;
			dispatch(['sub','-m','v1=something','-sbf','string','1.1']);
			equals(d.bt.map['v1'],'something');
			equals(d.bt.string,'string');
			equals(d.bt.fvar,1.1);
			isTrue(d.bt.didRunDefault);

			// fallback to upper dispatch
			d.bt.didRunDefault = false;
			dispatch(['sub','-s','thestring','sub','-s','otherstring']);
			isTrue(d.bt.didRunDefault);
			equals(d.bt.string,'otherstring');

			d.bt.didRunDefault = false;
			d.bt.preventDefault();
			dispatch(['sub','-s','thestring']);
			isFalse(d.bt.didRunDefault);
			equals(d.bt.string,'thestring');

			// fallback to upper dispatch
			dispatch(['sub','-s','thestring','sub','-ss','otherstring','anotherstring']);
			isFalse(d.bt.didRunDefault);
			equals(d.bt.string,'anotherstring');
		}
	}

	public static function raises(fn:Void->Void)
	{
		var didFail = false;
		try
		{
			fn();
			utest.Assert.fail();
		}
		catch(e:DispatchError)
		{
			didFail = true;
		}
		utest.Assert.isTrue(didFail);
	}
}

class BasicTypes extends mcli.CommandLine
{
	/**
		@alias b
	 **/
	public var bool:Bool = false;
	/**
		@alias s
	 **/
	public var string:String = 'hello';

	/**
		@alias i
	**/
	public var ivar:Int = 0;

	/**
		@alias f
	**/
	public var fvar:Float = 0;

	/**
		@alias m
	 **/
	public var map:Map<String,String> = new Map();

	@:skip public var didRunDefault:Bool;
	public function runDefault()
	{
		this.didRunDefault = true;
	}
}

class WithSubDispatch extends CommandLine
{
	@:skip public var i:Int;
	/**
		@alias O
	**/
	public function oneArg(i:Int)
	{
		this.i = i;
	}

	@:skip public var f:Float;
	/**
		@alias T
	 **/
	public function twoArgs(i:Int,f:Float)
	{
		this.i = i;
		this.f = f;
	}

	@:skip public var bt:BasicTypes = new BasicTypes();
	public function sub(d:Dispatch)
	{
		d.dispatch(bt,false);
	}

	@:skip public var varArgs:Array<String>;
}

class WithSubDispatchAndDefault extends WithSubDispatch
{
	public function runDefault(varArgs:Array<String>)
	{
		this.varArgs = varArgs;
	}
}
