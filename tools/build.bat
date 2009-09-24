@echo off

:: Change to batch file dir
cd /d %~dp0

call prebuild.bat
cd ..\src
haxe haxigniter.hxml
cd ..\tools
