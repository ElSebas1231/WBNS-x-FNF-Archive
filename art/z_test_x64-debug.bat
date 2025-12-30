@echo off
color 0b
cd ..
echo BUILDING GAME [Debug]
haxelib set flxanimate shadowdev
cmd /k lime test windows -debug
echo.
echo done.
pause