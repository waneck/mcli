package mcli.internal;

typedef Argument =
{
	command:String,
	alias:Null<String>,
	description:Null<String>,
	kind:Kind
}

enum Kind
{
	Flag;
	SubDispatch;
	VarHash;
	Var(t:Type);
	Function(args:Array<Type>);
}

enum Type
{
	TString;
	TInt;
	TFloat;
	TBool;
	TCustom(name:String):
}
