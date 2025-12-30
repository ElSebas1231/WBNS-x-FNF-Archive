package states;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.addons.display.FlxBackdrop;

class GalleryState extends MusicBeatState {
    var grid:FlxBackdrop;
    var topBG:FlxSprite;
    var bottomBG:FlxSprite;
    var shadow:FlxSprite;
    
    override function create() {
        var bgColor:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFF121227);
		add(bgColor);

		var bgStars:FlxSprite = new FlxSprite();
		bgStars.antialiasing = ClientPrefs.data.antialiasing;
		bgStars.loadGraphic(Paths.image('ui/menus/utils/stars'));
		add(bgStars);

        grid = new FlxBackdrop(Paths.image('ui/menus/titlemenu/checker'));
		grid.x = TitleState.gridXPosition;
		grid.y = TitleState.gridYPosition;
		grid.scale.set(0.3, 0.3);
		grid.velocity.set(40, 0);
		grid.alpha = 0.45;
		add(grid);

        // carpetas
        
        // imagenes

        shadow = new FlxSprite().loadGraphic(Paths.image('ui/menus/gallery/shadow'));
        shadow.scale.set(0.7, 0.7);
        shadow.screenCenter();
        add(shadow);

        topBG = new FlxSprite().loadGraphic(Paths.image('ui/menus/gallery/top'));
        topBG.scale.set(0.7, 0.7);
        topBG.screenCenter();
        add(topBG);

        bottomBG = new FlxSprite().loadGraphic(Paths.image('ui/menus/gallery/bottom'));
        bottomBG.scale.set(0.7, 0.7);
        bottomBG.screenCenter();
        add(bottomBG);

        super.create();
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