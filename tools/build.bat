@echo off

if "%1" == "-help" goto help
if "%2" == "--help" goto help

set SRCPATH=%~dp0\..\src

set OUTPUT=%1
if "%1" == "" set OUTPUT=%~dp0\..\bin\www
if "%1" == "-neko" set OUTPUT=%~dp0\..\bin\www

call %~dp0\prebuild.bat "%OUTPUT%"

if "%1" == "-neko" goto neko
if "%2" == "-neko" goto neko

set BUILDFILE=
if exist "%SRCPATH%\haxigniter.hxml" set BUILDFILE="%SRCPATH%\haxigniter.hxml"

:php
echo Building haXigniter for PHP...
haxe -cp "%SRCPATH%" -php "%OUTPUT%" -main haxigniter.Application %BUILDFILE%
goto end

:neko
echo Building haXigniter for Neko...
haxe -cp "%SRCPATH%" -neko "%OUTPUT%\index.n" -main haxigniter.Application %BUILDFILE%
goto end

:help
echo haXigniter build script
echo  Usage: build.bat [outputdir] [-neko]
echo  src/haxigniter.hxml can be used for custom arguments and libraries.
goto end

:end
