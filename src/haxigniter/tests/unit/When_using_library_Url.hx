package haxigniter.tests.unit;

import haxigniter.libraries.Url;

/**
* This is fun, unit testing a unit test class.
*/
class When_using_library_Url extends haxigniter.tests.TestCase
{
	public function test_Then_linkUrl_should_consider_script_file()
	{
		var config = haxigniter.application.config.Config.instance();
		var old = config.siteUrl;
		
		config.siteUrl = '/';
		this.assertEqual('', Url.linkUrl());
		
		config.siteUrl = '/index.php';
		this.assertEqual('', Url.linkUrl());

		config.siteUrl = '/test/index.php';
		this.assertEqual('/test', Url.linkUrl());

		config.siteUrl = old;
	}
}
