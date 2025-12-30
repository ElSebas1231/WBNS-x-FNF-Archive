package options;

import objects.FlagIcon;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

var alphabetHex:Alphabet;
var bg:FlxSprite;

class LanguageSubState extends MusicBeatSubstate
{
	#if TRANSLATIONS_ALLOWED
	var grpLanguages:FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();
	var grpFlags:FlxTypedGroup<FlagIcon> = new FlxTypedGroup<FlagIcon>();

	var languages:Array<String> = [];
	var colorsArray:Array<String> = [];
	var displayLanguages:Map<String, String> = [];
	var displayColorLanguages:Map<String, String> = [];
	var curSelected:Int = 0;
	public function new()
	{
		super();

		bg = new FlxSprite().loadGraphic(Paths.image('ui/menus/utils/bgMiscDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.screenCenter();
		add(bg);

		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, FlxColor.GRAY, FlxColor.WHITE));
		grid.velocity.set(40, 40);
		grid.alpha = 0.55;
		add(grid);

		add(grpLanguages);
		add(grpFlags);

		var upperBar:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 100, FlxColor.BLACK);
		add(upperBar);

		var bottomBar:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 200, FlxColor.BLACK);
		bottomBar.y = 620;
		add(bottomBar);

		alphabetHex = makeAlphabet(FlxG.width / 2, 20);
		alphabetHex.text = 'Choose your language';
		for (letter in alphabetHex.letters) { letter.color = FlxColor.WHITE; }
		add(alphabetHex);
		
		languages.push(ClientPrefs.defaultData.language); //English (US)
		displayLanguages.set(ClientPrefs.defaultData.language, Language.defaultLangName);
		displayColorLanguages.set(ClientPrefs.defaultData.language, Language.defaultLangColor);
		var directories:Array<String> = Mods.directoriesWithFile(Paths.getSharedPath(), 'data');
		for (directory in directories)
		{
			for (file in FileSystem.readDirectory(directory))
			{
				if(file.toLowerCase().endsWith('.lang'))
				{
					var langFile:String = file.substring(0, file.length - '.lang'.length).trim();
					
					//trace('File: ' + langFile);
					if(!languages.contains(langFile)) languages.push(langFile);

					if(!displayLanguages.exists(langFile))
					{
						var path:String = '$directory/$file';
						//trace(path);
						#if MODS_ALLOWED 
						var txt:String = File.getContent(path);
						#else
						var txt:String = Assets.getText(path);
						#end

						var id:Int = txt.indexOf('\n');
						if(id > 0) //language display name shouldnt be an empty string or null
						{
							var name:String = txt.substr(0, id).trim();
							if(!name.contains(':')) displayLanguages.set(langFile, name);

							var lines:Array<String> = txt.split("\n");
							for (line in lines) {
								if (line.indexOf("menu_color:") != -1) {
									var colorValue:String = line.split(":")[1].trim().replace("\"", "");
									displayColorLanguages.set(langFile, colorValue);
									//trace('Name: ' + langFile + ' Color: ' + colorValue);
									break;
								}
							}
						}
						else if(txt.trim().length > 0 && !txt.contains(':')) displayLanguages.set(langFile, txt.trim());
					}
				}
			}
		}

		languages.sort(function(a:String, b:String)
		{
			a = (displayLanguages.exists(a) ? displayLanguages.get(a) : a).toLowerCase();
			b = (displayLanguages.exists(b) ? displayLanguages.get(b) : b).toLowerCase();
			if (a < b) return -1;
			else if (a > b) return 1;
			return 0;
		});

		//trace(ClientPrefs.data.language);
		curSelected = languages.indexOf(ClientPrefs.data.language);
		if(curSelected < 0)
		{
			//trace('Language not found: ' + ClientPrefs.data.language);
			ClientPrefs.data.language = ClientPrefs.defaultData.language;
			curSelected = Std.int(Math.max(0, languages.indexOf(ClientPrefs.data.language)));
		}

		for (num => lang in languages)
		{
			var name:String = displayLanguages.get(lang);
			if(name == null) name = lang;

			var text:Alphabet = new Alphabet(20, 220, name, true);
			text.isMenuItem = true;
			text.targetY = num;
			text.changeX = false;
			text.distancePerItem.y = 95;
			text.snapToPosition();
			grpLanguages.add(text);

			var langFlag:FlagIcon = new FlagIcon(lang);
			langFlag.sprTracker = text;
			grpFlags.add(langFlag);
		}
		changeSelected();
	}

	var holdTime:Float = 0;
	var changedLanguage:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var mult:Int = (FlxG.keys.pressed.SHIFT) ? 3 : 1;
		if(controls.UI_UP_P) {
			changeSelected(-1 * mult);
			holdTime = 0;
		}

		if(controls.UI_DOWN_P) {
			changeSelected(1 * mult);
			holdTime = 0;
		}
		if(FlxG.mouse.wheel != 0) {
			changeSelected(FlxG.mouse.wheel * mult);
			holdTime = 0;
		}

		if(controls.BACK) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.resetState();
			
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0) {
					changeSelected((checkNewHold - checkLastHold) * (controls.UI_DOWN ? mult : -mult));
				}
			}

		if(controls.ACCEPT) {
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.6);
			ClientPrefs.data.language = languages[curSelected];
			ClientPrefs.saveSettings();
			Language.reloadPhrases();
			changedLanguage = true;
		}
	}

	function changeSelected(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, languages.length-1);
		var curColor = displayColorLanguages.get(languages[curSelected]);
		
		for (num => lang in grpLanguages)
		{
			lang.targetY = num - curSelected;
			lang.alpha = 0.6;
			if(num == curSelected) lang.alpha = 1;
		}

		for (i in 0...grpFlags.members.length) { grpFlags.members[i].alpha = 0.6; }
		grpFlags.members[curSelected].alpha = 1;

		for (letter in alphabetHex.letters) {
			FlxTween.cancelTweensOf(letter);
			FlxTween.color(letter, 0.5, letter.color, curColor == null ? FlxColor.fromString('#' + Language.defaultLangColor) : FlxColor.fromString('#' + curColor), {ease: FlxEase.smoothStepOut});
		}

		FlxTween.cancelTweensOf(bg);
		FlxTween.color(bg, 0.5, bg.color, curColor == null ? FlxColor.fromString('#' + Language.defaultLangColor) : FlxColor.fromString('#' + curColor), {ease: FlxEase.smoothStepOut});

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
	}

	function makeAlphabet(x:Float = 0, y:Float = 0):Alphabet
	{
		var text:Alphabet = new Alphabet(x, y, '', true);
		text.alignment = CENTERED;
		text.setScale(0.8);
		add(text);
		return text;
	}
	#else
	public var errorSine:Float = 0;
	public var errorText:FlxText;
	override function create()
	{
		var bg = new FlxSprite().loadGraphic(Paths.image('ui/menus/utils/bgMiscDesat'));
		bg.color = FlxColor.GRAY;
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		bg.screenCenter();

		errorText = new FlxText(0, 0, FlxG.width - 300, 'Las traducciones no están activadas.\nPresiona ACCEPT ó BACK para volver al menú principal', 32);
		errorText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		errorText.scrollFactor.set();
		errorText.borderSize = 2;
		errorText.screenCenter();
		add(errorText);
		super.create();
	}

	override function update(elapsed:Float)
	{
		errorSine += 90 * elapsed;
		errorText.alpha = 1 - Math.sin((Math.PI * errorSine) / 90);

		if (controls.ACCEPT || controls.BACK) {
			MusicBeatState.switchState(new states.MainMenuState());
		}

		super.update(elapsed);
	}
	#end
}