package haxigniter.views;

interface IViewEngine 
{
	/**
	 * Assign a value to a template variable, replacing if it already exists.
	 * @param	var name
	 * @param	var value
	 */
	function Assign(name : String, value : Dynamic) : Void;
	
	/**
	 * Clear the assignment of a template variable.
	 * @param	name
	 * @return  true if the variable existed.
	 */
	function ClearAssign(name : String) : Bool;
	
	/**
	 * Render a template based on the template variables.
	 * @param	content
	 * @return  the rendered template.
	 */
	function Render(content : String) : String;
	
	/**
	 * Render the contents of a file.
	 * @param	fileName
	 * @return  the rendered template.
	 */
	function RenderFile(fileName : String) : String;
}