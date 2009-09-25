@echo off

:: Change to batch file dir
cd /d %~dp0
call prebuild.bat
cd ..\src

if "%1" == "neko" goto neko

echo Building haXigniter for php...
haxe haxigniter_php.hxml
goto end

:neko
echo Building haXigniter for neko...
haxe haxigniter_neko.hxml

:end
cd ..\tools
