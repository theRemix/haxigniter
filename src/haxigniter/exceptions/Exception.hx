package haxigniter.exceptions;

class Exception
{
	public var Message(getMessage, null) : String;
	private var message : String;
	private function getMessage() { return this.message; }

	public var Code(getCode, null) : Int;
	private var code : Int;
	private function getCode() { return this.code; }
	
	public var Stack(getStack, null) : haxe.PosInfos;
	private var stack : haxe.PosInfos;
	private function getStack() { return this.stack; }
	
	public function new(message : String, ?code : Int = 0, ?stack : haxe.PosInfos )
	{
#if php
		message = StringTools.htmlEscape(message);
#end
		this.message = message;
		this.code = code;
		this.stack = stack;
	}
	
	public function toString() : String
	{
		var msg : String = '[' + this.stack.className + " -> ";
		msg += this.stack.methodName + "() line ";
		msg += this.stack.lineNumber + "] " + this.message;

		return msg;
	}
}