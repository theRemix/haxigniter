@echo off

:: Set output path
set PBOUTPUT=%1
if "%1" == "" set PBOUTPUT=%~dp0\..\bin\www

:: Set paths for application output and source dir
set PBOUTPUTAPP=%PBOUTPUT%\lib\haxigniter\application
set PBAPPSRC=%~dp0\..\src\haxigniter\application

:: ----- .htaccess --------------------------------------------------

:: Copy .htaccess to lib folder
%~dp0\robocopy /NJH /NJS "%~dp0\..\src" "%PBOUTPUT%\lib" .htaccess

:: ----- Runtime ----------------------------------------------------

:: Copy runtime folders to application
%~dp0\robocopy /NJH /NJS /E "%PBAPPSRC%\runtime" "%PBOUTPUTAPP%\runtime" /XF .gitignore

:: ----- Synchronize views ------------------------------------------

%~dp0\robocopy /NJH /NJS /MIR "%PBAPPSRC%\views" "%PBOUTPUTAPP%\views" /XF .gitignore

:: ----- Synchronize external libraries -----------------------------

%~dp0\robocopy /NJH /NJS /MIR "%PBAPPSRC%\external" "%PBOUTPUTAPP%\external" /XF .gitignore *.hx

:: Exit code must be explicitly set sometimes for robocopy.
:: Thanks for the hint: http://tylermac.wordpress.com/2009/09/06/haxe-php-smarty-flashdevelop/#Implementation
exit /B 0
