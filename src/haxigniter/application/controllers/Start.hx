package haxigniter.application.controllers;

/**
 * The Start controller
 * Start is the default controller name, so http://yourhostname/ will go here.
 * 
 * This controller is a RestController, which follows the RESTful approach used in Ruby on Rails.
 * A request like http://yourhostname/start/123 will map to the show() method.
 * 
 * Please look at haxigniter/libraries/RestController.hx for a full reference of the mappings.
 * 
 */
class Start extends haxigniter.libraries.RestController
{
	public function new()
	{
		// Some default view assignments for every page
		this.view.assign('application', 'haXigniter');
		this.view.assign('link', haxigniter.libraries.Url.siteUrl());
	}
	
	public function index()
	{
		// Displays 'start/index.mtt' (className/method, extension is from the ViewEngine.)
		this.view.displayDefault();		
	}

	public function show(id : Int)
	{
		this.view.assign('id', id);
		this.view.display('start/index.mtt');
	}
	
	public function create(posted : Hash<String>)
	{
		// this.trace() gives a nicer trace output.
		this.trace(posted);
		this.view.display('start/index.mtt');
	}
}
