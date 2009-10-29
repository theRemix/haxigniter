@echo off
:: Unit test runner

SET OLDDIR=%CD%
cd /D %~dp0\unittest

haxe -cp ../../src -main UnitTest -neko unittest.n
neko unittest.n %1

del unittest.n
cd /D %OLDDIR%
