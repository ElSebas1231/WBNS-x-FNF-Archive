package states;

import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUITabMenu;
import substates.StickerSubState;

class TestState extends MusicBeatState {
    var stickerSubState:StickerSubState;
    var inputStickerSet:FlxUIInputText;
    var inputStickerPack:FlxUIInputText;
	private var blockPressWhileTypingOn:Array<FlxUIInputText> = [];

    var missingText:FlxText;
	var missingTextTimer:FlxTimer;
    var UI_box:FlxUITabMenu;

    public function new(?stickers:StickerSubState = null)
	{
		super();
	  
		if (stickers != null)
		{
			stickerSubState = stickers;
		}
	}

    override public function create():Void {
        super.create();

        var tabs = [
			{name: "Data", label: 'Data'}
		];

        UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(200, 200);
		UI_box.x = 640 + 40 / 2;
		UI_box.y = 25;
		UI_box.scrollFactor.set();
        add(UI_box);

        var tab_group_data = new FlxUI(null, UI_box);
		tab_group_data.name = 'Data';

        inputStickerSet = new FlxUIInputText(10, 10, 200, '', 8);
        inputStickerPack = new FlxUIInputText(10, 40, 200, '', 8);

        tab_group_data.add(inputStickerSet);
        blockPressWhileTypingOn.push(inputStickerSet);

        tab_group_data.add(inputStickerPack);
        blockPressWhileTypingOn.push(inputStickerPack);
        UI_box.addGroup(tab_group_data);
        
        if (stickerSubState != null && !ClientPrefs.data.noStickers) {
			openSubState(stickerSubState);
			stickerSubState.degenStickers();
		}

        if (FlxG.sound.music != null) FlxG.sound.music.volume = 0;
        
        FlxG.camera.bgColor = 0xFF00FFFF;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        var blockInput:Bool = false;
        for (inputText in blockPressWhileTypingOn) {
            if(inputText.hasFocus) {
                ClientPrefs.toggleVolumeKeys(false);
                blockInput = true;
                break;
            }
        }

        if(!blockInput){
            ClientPrefs.toggleVolumeKeys(true);
            if (FlxG.keys.justPressed.ENTER) {
                if (inputStickerSet.text != "" && inputStickerPack.text != "") {
                    StickerSubState.STICKER_SET = inputStickerSet.text;
                    StickerSubState.STICKER_PACK = inputStickerPack.text;
        
                    openSubState(cast new StickerSubState(null, (sticker) -> new TestState(sticker)));
                } else {
                    showMissingTextMessage();
                }
            }

            if (FlxG.keys.justPressed.BACKSPACE) {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                if (FlxG.sound.music != null) FlxG.sound.music.volume = 1;
                MusicBeatState.switchState(new MainMenuState());
            }
        }
    }

    function showMissingTextMessage():Void {
        if (missingText == null) {
            missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
            missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            missingText.scrollFactor.set();
            add(missingText);
        } else {
            missingTextTimer.cancel();
        }
    
        missingText.text = 'Por favor, introduce valores válidos para STICKER_SET y STICKER_PACK';
        missingText.screenCenter(Y);
        missingTextTimer = new FlxTimer().start(5, function(tmr:FlxTimer) {
            remove(missingText);
            missingText.destroy();
        });
    }
}