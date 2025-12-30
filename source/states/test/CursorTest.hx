package states.test;

import flixel.input.mouse.FlxMouseEventManager;

class CursorTest extends MusicBeatState {
    var defaultCursor:FlxSprite;
    var crossCursor:FlxSprite;
    var eraserCursor:FlxSprite;
    var grabbingCursor:FlxSprite;
    var pointerCursor:FlxSprite;

    override function create() {
        FlxG.camera.color = FlxColor.CYAN;

        defaultCursor = new FlxSprite().makeGraphic(20, 20, FlxColor.WHITE);
        defaultCursor.screenCenter();
        add(defaultCursor);

        crossCursor = new FlxSprite(defaultCursor.x + 50, defaultCursor.y).makeGraphic(20, 20, FlxColor.RED);
        add(crossCursor);

        eraserCursor = new FlxSprite(defaultCursor.x - 50, defaultCursor.y).makeGraphic(20, 20, FlxColor.BLUE);
        add(eraserCursor);

        grabbingCursor = new FlxSprite(defaultCursor.x - 100, defaultCursor.y).makeGraphic(20, 20, FlxColor.GREEN);
        add(grabbingCursor);

        pointerCursor = new FlxSprite(defaultCursor.x + 100, defaultCursor.y).makeGraphic(20, 20, FlxColor.YELLOW);
        add(pointerCursor);

        for (spr in [defaultCursor, crossCursor, eraserCursor, grabbingCursor, pointerCursor]) {
            var cursorEvents = new FlxMouseEventManager();
			cursorEvents.add(spr, null, onOut, onOver, onOut);
			add(cursorEvents);
        }

        super.create();
    }

    function onOver(target:FlxSprite) {
        if (target == defaultCursor) Cursor.cursorMode = Default;
        if (target == crossCursor) Cursor.cursorMode = Cross;
        if (target == eraserCursor) Cursor.cursorMode = Eraser;
        if (target == grabbingCursor) Cursor.cursorMode = Grabbing;
        if (target == pointerCursor) Cursor.cursorMode = Pointer;
    }

    function onOut(target:FlxSprite) {
        for (spr in [defaultCursor, crossCursor, eraserCursor, grabbingCursor, pointerCursor]) {
            if (target == spr) {
                Cursor.cursorMode = Default;
            }
        }
    }

    var exitting:Bool = false;
    override function update(elapsed:Float) {
        if (!exitting) {
            if (controls.BACK) {
                exitting = true;
                MusicBeatState.switchState(new MainMenuState());
            }
        }

        super.update(elapsed);
    }
}