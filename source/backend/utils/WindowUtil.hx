package backend.utils;

import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.input.keyboard.FlxKey;
import backend.ClientPrefs;

//Utilities for operating on the current window, such as changing the title.
#if (cpp && windows)
@:cppFileCode('
	#include <iostream>
	#include <windows.h>
	#include <psapi.h>
')
#end

class WindowUtil
{
	/**
	 * Dispatched when the game window is closed.
	*/
	public static final windowExit:FlxTypedSignal<Int->Void> = new FlxTypedSignal<Int->Void>();

	/**
	 * Wires up FlxSignals that happen based on window activity.
	 * For example, we can run a callback when the window is closed.
	*/
	public static function initWindowEvents():Void
	{
		// onUpdate is called every frame just before rendering.

		// onExit is called when the game window is closed.
		openfl.Lib.current.stage.application.onExit.add(function(exitCode:Int) {
			windowExit.dispatch(exitCode);
		});

		openfl.Lib.current.stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, (e:openfl.events.KeyboardEvent) -> {
			if (FlxG.keys.anyJustPressed(ClientPrefs.keyBinds['fullscreen'])) {
				openfl.Lib.application.window.fullscreen = !openfl.Lib.application.window.fullscreen;
				FlxG.save.data.fullscreen = openfl.Lib.application.window.fullscreen;
			}
		});
	}

	//Turns off that annoying "Report to Microsoft" dialog that pops up when the game crashes.
	public static function disableCrashHandler():Void
	{
	#if (cpp && windows)
	untyped __cpp__('SetErrorMode(SEM_FAILCRITICALERRORS | SEM_NOGPFAULTERRORBOX);');
	#else
	// Do nothing.
	#end
	}
}