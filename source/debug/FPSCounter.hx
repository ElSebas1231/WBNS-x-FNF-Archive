package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import backend.utils.MemoryUtil;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
class FPSCounter extends TextField
{
	public var currentFPS(default, null):Int;
	@:noCompletion private var times:Array<Float>;

	var memPeak:Float = 0;
	static final BYTES_PER_MEG:Float = 1024 * 1024;
	static final ROUND_TO:Float = 1 / 100;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 14, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		times = [];
	}

	var deltaTimeout:Float = 0.0;
	var mem:Float = 0.0;

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{
		// prevents the overlay from updating every frame, why would you need to anyways
		if (deltaTimeout > 1000) {
			deltaTimeout = 0.0;
			return;
		}

		mem = Math.fround(MemoryUtil.getMemoryUsed() / BYTES_PER_MEG / ROUND_TO) * ROUND_TO;

		if (mem > memPeak) memPeak = mem;

		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;		
		updateText();
		deltaTimeout += deltaTime;
	}

	public dynamic function updateText():Void { // so people can override it in hscript
		text = 'FPS: ${currentFPS}'
		+ '\nRAM: ${mem}mb / PEAK: ${memPeak}mb';

		#if (develop || debug)
			var currentState:String;

			//currentState = FlxG.state.toString();
			currentState = Type.getClassName(Type.getClass(FlxG.state));
			text += "\nCurrent State: " + currentState;

			var objectCount:Int;

			objectCount = FlxG.state.members.length;
			text += "\nObject Count: " + objectCount;

			var mouseX:Int;
			var mouseY:Int;

			mouseX = FlxG.mouse.screenX;
			mouseY = FlxG.mouse.screenY;
			text += "\nMouse Position: (" + mouseX + ", " + mouseY + ")";
		#end

		textColor = 0xFFFFFFFF;
		if (currentFPS < FlxG.drawFramerate * 0.5)
			textColor = 0xFFFF0000;
	}
}
