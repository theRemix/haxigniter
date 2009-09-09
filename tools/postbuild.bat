@echo off
:: Change to batch file dir
cd /d %~dp0
:: Need to start a new shell since xcopy is bugged when executing under another process. More info:
:: http://social.msdn.microsoft.com/Forums/en-US/netfxbcl/thread/ab3c0cc7-83c2-4a86-9188-40588b7d1a52/
:: http://stackoverflow.com/questions/567912/why-would-c-processstartinforedirectstandardoutput-cause-xcopy-process-to-fail/568327
:: http://www.flashdevelop.org/community/viewtopic.php?f=13&t=3876

:: Copy views to application/views since they are external resources.
cmd /q /c start /i xcopy /E /Y ..\src\haxigniter\application\views ..\bin\www\lib\haxigniter\application\views\
