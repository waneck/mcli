package mcli;

enum DispatchError
{
	UnknownArgument(arg:String);
	ArgumentFormatError(type:String, passed:String);
	DecoderNotFound(type:String);
}
