@echo off

:: Change to batch file dir
cd /d %~dp0

:: Set paths
set OUTPUT=..\bin\www\lib\haxigniter\application\
set APP=..\src\haxigniter\application

:: ----- .htaccess --------------------------------------------------

:: Copy .htaccess to lib folder
robocopy /NJH /NJS ..\src ..\bin\www\lib .htaccess

:: ----- Runtime ----------------------------------------------------

:: Copy runtime folders to application
robocopy /NJH /NJS /E %APP%\runtime %OUTPUT%\runtime\ /XF .gitignore

:: ----- Synchronize views ------------------------------------------

robocopy /NJH /NJS /MIR %APP%\views %OUTPUT%\views /XF .gitignore

:: ----- Synchronize external libraries -----------------------------

robocopy /NJH /NJS /MIR %APP%\external %OUTPUT%\external *.php /XF .gitignore

:: Exit code must be explicitly set sometimes.
:: Thanks for the hint: http://tylermac.wordpress.com/2009/09/06/haxe-php-smarty-flashdevelop/#Implementation
exit /B 0
