package mcli.internal;

typedef Argument =
{
	name:String,
	command:String,
	aliases:Null<Array<String>>,
	description:Null<String>,
	kind:Kind
}

enum Kind
{
	//stub
	Message;
	//variable
	Flag;
	VarHash(key:{ name:String, t:CType }, value:{ name:String, t:CType }, ?valueIsArray:Bool);
	Var(t:CType);
	//function
	Function(args:Array<{name:String, opt:Bool, t:CType}>, ?varArgs:Null<CType>);
	SubDispatch;
}

typedef CType = String;
