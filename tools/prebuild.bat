@echo off

:: Change to batch file dir
cd /d %~dp0

:: Set output path
set OUTPUT=%1
if "%1" == "" set OUTPUT=..\bin\www

:: Set paths
set OUTPUTAPP=%OUTPUT%\lib\haxigniter\application\
set APPSRC=..\src\haxigniter\application

:: ----- .htaccess --------------------------------------------------

:: Copy .htaccess to lib folder
robocopy /NJH /NJS ..\src %OUTPUT%\lib .htaccess

:: ----- Runtime ----------------------------------------------------

:: Copy runtime folders to application
robocopy /NJH /NJS /E %APPSRC%\runtime %OUTPUTAPP%\runtime\ /XF .gitignore

:: ----- Synchronize views ------------------------------------------

robocopy /NJH /NJS /MIR %APPSRC%\views %OUTPUTAPP%\views /XF .gitignore

:: ----- Synchronize external libraries -----------------------------

robocopy /NJH /NJS /MIR %APPSRC%\external %OUTPUTAPP%\external *.php /XF .gitignore

:: Exit code must be explicitly set sometimes.
:: Thanks for the hint: http://tylermac.wordpress.com/2009/09/06/haxe-php-smarty-flashdevelop/#Implementation
exit /B 0
