package mcli;

/**
	In order to support custom types, one must provide a custom Decoder implementation
**/
typedef Decoder<T> =
{
	function fromString(s:String):T;
}
