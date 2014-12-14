import utest.*;
import utest.ui.Report;
import tests.*;

class Test
{
	static function main()
	{
		var runner = new Runner();

		runner.addCase(new McliTests());
		Report.create(runner);

		var r:TestResult = null;
		runner.onProgress.add(function(o) if (o.done == o.totals) r = o.result);
		runner.run();

#if sys
		if (r.allOk())
			Sys.exit(0);
		else
			Sys.exit(1);
#end
	}
}
