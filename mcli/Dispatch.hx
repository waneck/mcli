package mcli;
import mcli.DispatchError;
import mcli.internal.Data;
#if macro
import haxe.macro.Expr;
import haxe.macro.*;
#end

class Dispatch
{
	private static function getAliases(arg:Argument)
	{
		var versions = arg.aliases != null ? arg.aliases.concat([arg.command]) : [arg.command];
		versions = versions.filter(function(s) return s != null && s != "");

		var prefix = "-";
		if (arg.kind == SubDispatch || arg.kind == Message)
			prefix = "";
		return versions.map(function(v) return (v.length == 1 || versions.length == 1) ? prefix + v : prefix + prefix + v);
	}

	/**
		Formats an argument definition to String.
		[argSize] maximum argument string length
		[screenSize] maxium characters until a line break should be forced
	**/
	public static function argToString(arg:Argument, argSize=30, screenSize=80)
	{
		var postfix = "";
		switch(arg.kind)
		{
			case VarHash(_,_,_):
				postfix = " key[=value]";
			case Var(_):
				postfix = "=value";
			case Function(args,vargs):
				postfix = " ";
				for (arg in args)
					postfix += (arg.opt ? "[" : "<") + arg.name + (arg.opt ? "]" : ">");
				if (vargs != null)
					postfix += " [arg1 [arg2 ...[argN]]]";
			default:
		}

		var versions = getAliases(arg);

		if (versions.length == 0)
			if (arg.description != null)
				return arg.description;
			else
				return "";
		versions.sort(function(s1,s2) return Reflect.compare(s1.length, s2.length));

		var desc = (arg.description != null ? arg.description : "");

		var ret = new StringBuf();
		ret.add("  ");
		ret.add(StringTools.rpad(versions.map(function(v) return v + postfix).join(", "), " ", argSize));
		ret.add("   ");
		if (arg.description != null)
			ret.add(arg.description);
		var consolidated = ret.toString();
		if (consolidated.length > screenSize)
		{
			ret = new StringBuf();
			var c = consolidated.split(" "), ccount = 0;
			for (word in c)
			{
				ccount += word.length + 1;
				if (ccount >= screenSize)
				{
					ret.addChar("\n".code);
					for (i in 0...(argSize + 5))
					ret.add(" ");
					ccount = argSize + 5;
				}
				ret.add(word);
				ret.add(" ");
			}
			return ret.toString();
		} else {
			return consolidated;
		}
	}

	/**
		With an argument definition array, it formats to show the standard usage help screen
		[screenSize] maximum number of characters before a line break is forced
	**/
	public static function showUsageOf(args:Array<Argument>, screenSize=80):String
	{
		var maxSize = 0;
		for (arg in args)
		{
			var size = arg.command.length;
			if (arg.aliases != null) for (a in arg.aliases)
			{
				size += a.length + 2;
			}

			if (size > maxSize)
				maxSize = size;
		}

		if (maxSize > 30) maxSize = 30;
		var buf = new StringBuf();
		for (arg in args)
		{
			var str = argToString(arg, maxSize, screenSize);
			if (str.length > 0)
			{
				buf.add(str);
				buf.addChar('\n'.code);
			}
		}
		return buf.toString();
	}

	private static var decoders:Map<String,Decoder<Dynamic>>;

	macro public static function addDecoder(decoder:ExprOf<Decoder<Dynamic>>)
	{
		var t = Context.typeof(decoder);
		var field = null;
		switch(Context.follow(t))
		{
			case TInst(c,_):
				for (f in c.get().fields.get())
				{
					if (f.name == "fromString")
					{
						field = f;
						break;
					}
				}
			case TAnonymous(a):
				for(f in a.get().fields)
				{
					if (f.name == "fromString")
					{
						field =f;
						break;
					}
				}
			default:
				throw new Error("Unsupported decoder type :" + TypeTools.toString(t), decoder.pos);
		}
		if (field == null)
			throw new Error("The type '" + TypeTools.toString(t) + "' is not compatible with a Decoder type", decoder.pos);
		var type = switch(Context.follow(field.type))
		{
			case TFun([arg],ret): //TODO test arg for string
				ret;
			default:
				throw new Error("The type '" + TypeTools.toString(field.type) + "' is not compatible with a Decoder type", decoder.pos);
		};

		var name = mcli.internal.Macro.convertType(type, decoder.pos);
		mcli.internal.Macro.registerDecoder(name);
		var name = { expr:EConst(CString(name)), pos: decoder.pos };

		return macro mcli.Dispatch.addDecoderRuntime($name, $decoder);
	}

	public static function addDecoderRuntime<T>(name:String, d:Decoder<T>):Void
	{
		if (decoders == null)
			decoders = new Map();
		decoders.set(name,d);
	}

	static function decode(a:String, type:String):Dynamic
	{
		return switch(type)
		{
			case "Int":
				var ret = Std.parseInt(a);
				if (ret == null) throw ArgumentFormatError(type,a);
				ret;
			case "Float":
				var ret = Std.parseFloat(a);
				if (Math.isNaN(ret))
					throw ArgumentFormatError(type,a);
				ret;
			case "String":
				a;
			default:
				var d = decoders != null ? decoders.get(type) : null;
				if (d == null) throw DecoderNotFound(type);
				d.fromString(a);
		};
	}

	private var args:Array<String>;

	public function new(args)
	{
		this.args = args.copy();
		this.args.reverse();
	}

	public function dispatch(v:mcli.CommandLine):Void
	{
		var defs = v.getArguments();
		var names = new Map();
		for (arg in defs)
			for (a in getAliases(arg))
				names.set(a, arg);

		while (args.length > 0)
		{
			var arg = args.pop();
			var argDef = names.get(arg);
			if (argDef == null)
			{
				argDef = names.get("runDefault");
			}
			if (argDef == null)
				throw UnknownArgument(arg);

			switch(argDef.kind)
			{
				case Flag:
					Reflect.setField(v, argDef.name, true);
				case VarHash(k,v,arr):
					var map:Map<Dynamic,Dynamic> = Reflect.field(v, argDef.name);
				case Function(fargs,varArg):
					var applied = [];
					for (fa in fargs)
					{
						arg = args.pop();
						applied.push(decode(arg, fa.t));
					}
					if (varArg != null)
					{
						var va = [];
						while (args.length > 0)
						{
							va.push(decode(arg,varArg));
						}
						applied.push(va);
					}
					Reflect.callMethod(v, Reflect.field(v, argDef.name), applied);
				default:
			}
		}
	}
}
