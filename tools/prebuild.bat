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
robocopy /NJH /NJS /E %APP%\runtime %OUTPUT%\runtime\ /XD .svn

:: ----- Synchronize views ------------------------------------------

robocopy /NJH /NJS /MIR %APP%\views %OUTPUT%\views /XD .svn

:: ----- Synchronize external libraries -----------------------------

robocopy /NJH /NJS /MIR %APP%\external %OUTPUT%\external *.php /XD .svn
