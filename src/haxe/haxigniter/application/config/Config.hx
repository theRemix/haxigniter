package haxigniter.application.config; class Config implements Dynamic { public function new() {
var documentRoot : String = untyped __var__('_SERVER', 'DOCUMENT_ROOT');

/* =============================================================== */
/* ===== Configuration file start, edit only below here ========== */
/* =============================================================== */

/*
|--------------------------------------------------------------------------
| Development setting
|--------------------------------------------------------------------------
|
| Determine here when the system is in development mode, or set to false.
|
*/
this.Development = php.Sys.getEnv('OS') == 'Windows_NT';

/*
|--------------------------------------------------------------------------
| Index File
|--------------------------------------------------------------------------
|
| Typically this will be your index.php file, unless you've renamed it to
| something else. If you are using mod_rewrite to remove the page set this
| variable so that it is blank.
|
*/
this.IndexPage = 'index.php';

/*
|--------------------------------------------------------------------------
| Base Site URL
|--------------------------------------------------------------------------
|
| URL to your CodeIgniter root. Typically this will be your base URL,
| WITH a trailing slash:
|
|	http://www.your-site.com/
|
*/
this.BaseUrl = untyped __var__('_SERVER', 'SERVER_PORT') == '443' ? 'https' : 'http';
this.BaseUrl += '://' + untyped __var__('_SERVER', 'HTTP_HOST');
this.BaseUrl += StringTools.replace(untyped __var__('_SERVER', 'SCRIPT_NAME'), this.IndexPage, '');

/*
|--------------------------------------------------------------------------
| URI PROTOCOL
|--------------------------------------------------------------------------
|
| This item determines which server global should be used to retrieve the
| URI string.  The default setting of "AUTO" works for most servers.
| If your links do not seem to work, try one of the other delicious flavors:
|
| 'AUTO'			Default - auto detects
| 'PATH_INFO'		Uses the PATH_INFO
| 'QUERY_STRING'	Uses the QUERY_STRING
| 'REQUEST_URI'		Uses the REQUEST_URI
| 'ORIG_PATH_INFO'	Uses the ORIG_PATH_INFO
|
*/
// TODO: Is this needed?

/*
|--------------------------------------------------------------------------
| Default Language
|--------------------------------------------------------------------------
|
| This determines which set of language files should be used. Make sure
| there is an available translation if you intend to use something other
| than english.
|
*/
this.Language = 'english';

/*
|--------------------------------------------------------------------------
| Default Character Set
|--------------------------------------------------------------------------
|
| This determines which character set is used by default in various methods
| that require a character set to be provided.
|
*/
this.Charset = 'UTF-8';

/*
|--------------------------------------------------------------------------
| Allowed URL Characters
|--------------------------------------------------------------------------
|
| This lets you specify which characters are permitted within your URLs.
| When someone tries to submit a URL with disallowed characters they will
| get a warning message.
|
| As a security measure you are STRONGLY encouraged to restrict URLs to
| as few characters as possible.  By default only these are allowed: a-z 0-9~%.:_-
|
| Leave blank to allow all characters -- but only if you are insane.
|
| DO NOT CHANGE THIS UNLESS YOU FULLY UNDERSTAND THE REPERCUSSIONS!!
|
| NOTE: When adding swedish charaters, the dash must be placed after them
| and the equal sign before... Must be some regexp problem.
*/
this.PermittedUriChars = 'a-z 0-9~%.:_-'; //'a-z 0-9~%.:=_���������-';

/*
|--------------------------------------------------------------------------
| Error Logging Threshold
|--------------------------------------------------------------------------
|
| If you have enabled error logging, you can set an error threshold to 
| determine what gets logged. Threshold options are:
| You can enable error logging by setting a threshold over zero. The
| threshold determines what gets logged. Threshold options are:
|
|	0 = Disables logging, Error logging TURNED OFF
|	1 = Error Messages (including PHP errors)
|	2 = Informational Messages
|	3 = Debug Messages			// NOTE: Info/debug swapped in MY_Log.php
|	4 = All Messages
|
| For a live site you'll usually only enable Errors (1) to be logged otherwise
| your log files will fill up very fast.
|
*/
this.LogThreshold = 2;

/*
|--------------------------------------------------------------------------
| Error Logging Directory Path
|--------------------------------------------------------------------------
|
| Leave this BLANK unless you would like to set something other than the default
| system/logs/ folder.  Use a full server path with trailing slash.
|
*/
this.LogPath = '';

/*
|--------------------------------------------------------------------------
| Date Format for Logs
|--------------------------------------------------------------------------
|
| Each item that is logged has an associated date. You can use PHP date
| codes to set your own date formatting
|
*/
this.LogDateFormat = 'Y-m-d H:i:s';

/*
|--------------------------------------------------------------------------
| Cache Directory Path
|--------------------------------------------------------------------------
|
| Leave this BLANK unless you would like to set something other than the default
| system/cache/ folder.  Use a full server path with trailing slash.
|
*/
this.CachePath = '';

/*
|--------------------------------------------------------------------------
| Private Directory Path
|--------------------------------------------------------------------------
|
| Set this to a folder outside the http document root where the web server
| has access. Can be used for session, sensitive data, etc.
| Use a full server path with trailing slash.
|
*/
this.PrivatePath = documentRoot.substr(0, documentRoot.lastIndexOf('/')) + '/www_private/';

/*
|--------------------------------------------------------------------------
| Session Path
|--------------------------------------------------------------------------
|
| Set this to an existing folder to automatically set session save path.
| Make sure the server can write to the folder.
|
*/
this.SessionPath = this.PrivatePath + 'session';

/*
|--------------------------------------------------------------------------
| Encryption Key
|--------------------------------------------------------------------------
|
| If you use the Encryption class or the Sessions class with encryption
| enabled you MUST set an encryption key.  See the user guide for info.
|
*/
this.EncryptionKey = '';

/* =============================================================== */
/* ===== Configuration file end, edit only above here ============ */
/* =============================================================== */

if(this.SessionPath != '')
{
	php.Session.setSavePath(this.SessionPath);
}

}

public var Development : Bool;
public var IndexPage : String;
public var BaseUrl : String;
public var Language : String;
public var Charset : String;
public var PermittedUriChars : String;
public var LogThreshold : Int;
public var LogPath : String;
public var LogDateFormat : String;
public var CachePath : String;
public var PrivatePath : String;
public var EncryptionKey : String;

public static function Instance() { return instance; }
private static var instance = new Config();
}
