@echo off
color 0b
cd ..
echo BUILDING GAME [Test]
haxelib set flxanimate shadowdev
cmd /k lime test windows
echo.
echo done.
pause