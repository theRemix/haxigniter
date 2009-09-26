@echo off

:: Change to batch file dir
cd /d %~dp0

set OUTPUT=%1
if "%1" == "" set OUTPUT=..\bin\www
if "%1" == "-neko" set OUTPUT=..\bin\www

call prebuild.bat %OUTPUT%

if "%1" == "-neko" goto neko
if "%2" == "-neko" goto neko

echo Building haXigniter for PHP...
haxe -cp ..\src -php %OUTPUT% -main haxigniter.Application
goto end

:neko
echo Building haXigniter for Neko...
haxe -cp ..\src -neko %OUTPUT%\index.n -main haxigniter.Application

:end
