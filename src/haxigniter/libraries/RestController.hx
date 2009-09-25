package haxigniter.libraries;

/**
 * Use this class instead of Controller to get a Ruby on Rails-inspired RESTful approach.
 * "classname" is your controller class, "ID" is any identifier that will be casted to the type T of your choice.
 * 
 * GET-requests:
 * 
 *  /classname           -> index()
 *  /classname/new       -> make()
 *  /classname/ID        -> show(id : T)
 *  /classname/ID/edit   -> edit(id : T)
 *  /classname/ID/delete -> destroy(id : T)
 * 
 * POST-requests:
 * 
 *  /classname           -> create(formData : Hash<String>)
 *  /classname/ID        -> update(id : T, formData : Hash<String>)
 * 
 * 
 * Thanks to Thomas on the haXe list for the inspiration.
 * 
 * For more info about the RESTful approach, here's a tutorial:
 * http://www.softiesonrails.com/search?q=Rest+101%3A+Part
 * 
 */
class RestController extends haxigniter.libraries.Controller {}
