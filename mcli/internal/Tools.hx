package mcli.internal;
using StringTools;

class Tools
{
	public static function toDashSep(s:String):String
	{
		if (s.length <= 1) return s; //allow upper-case aliases
		var buf = new StringBuf();
		var first = true;
		for (i in 0...s.length)
		{
			var chr = s.charCodeAt(i);
			if (chr >= 'A'.code && chr <= 'Z'.code)
			{
				if (!first)
					buf.addChar('-'.code);
				buf.addChar( chr - ('A'.code - 'a'.code) );
				first = true;
			} else {
				buf.addChar(chr);
				first = false;
			}
		}

		return buf.toString();
	}

	public static function parseComments(c:String):Array<{ tag:Null<String>, contents:String }>
	{
		var ret = [];
		var curTag = null;
		var txt = new StringBuf();
		for (ln in c.split("\n"))
		{
			var i = 0, len = ln.length;
			while (i < len)
			{
				switch(ln.fastCodeAt(i))
				{
				case ' '.code, '\t'.code, '*'.code: i++;
				case '['.code if (curTag == null):
					var tagP = ln.indexOf(']');
					if (tagP < 0)
						break;
					var tag = ln.substr(i+1, tagP - (i+1));
					ret.push({ tag: tag, contents: ln.substr(tagP + 1) });
					i = len;
					break;
				case '@'.code: //found a tag
					var t = txt.toString();
					txt = new StringBuf();
					if (curTag != null || t.length > 0)
					{
						ret.push({ tag:curTag, contents:t });
					}
					var begin = ++i;
					while(i < len)
					{
						switch(ln.fastCodeAt(i))
						{
							case ' '.code, '\t'.code:
								break;
							default: i++;
						}
					}
					curTag = ln.substr(begin, i - begin);
					break;
				default: break;
				}
			}
			if (i < len)
			{
				txt.add(ln.substr(i).replace("\r", "").trim());
				txt.addChar(' '.code);
			}
			txt.addChar('\n'.code);
		}

		var t = txt.toString().trim();
		if (curTag != null || t.length > 0)
			ret.push({ tag:curTag, contents: t });

		return ret;
	}
}
