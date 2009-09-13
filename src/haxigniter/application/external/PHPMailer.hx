package haxigniter.application.external;

import haxigniter.Application;

extern class PHPMailer 
{
	public static function __init__() : Void
	{
		haxigniter.libraries.Server.RequireExternal('phpmailer/class.phpmailer.php');
	}
	
	public function new(mode : Bool) : Void;
	
	public function AddReplyTo(email : String, name : String = '') : Void;
	public function AddAddress(email : String, name : String = '') : Void;
	public function SetFrom(email : String, name : String = '') : Void;
	public function AddAttachment(fileName : String, name : String = '', encoding : String = 'base64', type : String = 'application/octet-stream') : Bool;
	public function Send() : Bool;
	
	public var Subject : String;
	public var AltBody : String;
	public var MsgHTML : String;
}