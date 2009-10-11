class UnitTest
{
    static function main()
    {
        var args = neko.Sys.args();
        
        if(args[0] == '-help' || args[0] == '--help')
        {
            neko.Lib.println('haXigniter unit tester');
            neko.Lib.println(' Usage : unittest [-all]');
            neko.Lib.println(' -all : Run the whole haXigniter test suite, not just application tests.');
        }
        else
        {
            var tests = new haxigniter.application.tests.TestRunner(args[0] == '-all');
            neko.Lib.print(tests.runTests());
        }
    }
}